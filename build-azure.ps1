#
# Build Azure for Azure Landing Zones
#

function Get-BicepDeployment {
    param (
        [Parameter(Mandatory = $False)]
        [String]$Path = $PWD,

        [Parameter(Mandatory = $False)]
        [String]$DeploymentRoot = 'deployments/landing-zones/',

        [Parameter(Mandatory = $False)]
        [String[]]$LandingZone,

        [Parameter(Mandatory = $False)]
        [String[]]$Include
    )
    begin {
        $deploymentBase = Join-Path -Path $Path -ChildPath $DeploymentRoot;
        Write-Host "Getting deployments from: $deploymentBase" -ForegroundColor Cyan;
        $Subscription = @{ };
        $config = Get-BuildAzureConfig;
        $count = 0;
        $defaultMode = $config.defaults.mode;
        $defaultLocation = $config.defaults.location;
    }
    process {
        # Get all matching landing zones
        $all = @(Get-ChildItem -Path $deploymentBase -Recurse -Filter 'deploy.bicep' -File | Where-Object {
                if ($LandingZone) {
                    $landingZoneBase = $_.FullName.Replace($deploymentBase, '').Split([System.IO.Path]::DirectorySeparatorChar)[0];
                    $landingZoneBase -in $LandingZone;
                }
                else {
                    $True;
                }
            })

        # Get all deployments
        $all | ForEach-Object {
            $landingZoneName = $_.FullName.Replace($deploymentBase, '').Split([System.IO.Path]::DirectorySeparatorChar)[0];
            $name = $_.FullName.Replace($deploymentBase, '').Split([System.IO.Path]::DirectorySeparatorChar)[-2];

            # Filter by name if applicable
            if ($Null -eq $Include -or $Include.Length -eq 0 -or $name -in $Include) {
                $mode = $defaultMode;
                $location = $defaultLocation;
                $content = az bicep build --file $_.FullName --stdout 3>&1 2>&1 | ForEach-Object {
                    if ($_ -like "ERROR: *" -or $_ -like "*.bicep(*) : Error BCP*") {
                        Write-Error -Message ($_ -replace "ERROR: ", "");
                    }
                    elseif ($_ -like "WARNING: *" -or $_ -like "*.bicep(*) : Warning *") {
                        Write-Warning -Message ($_ -replace "WARNING: ", "");
                    }
                    else {
                        $_;
                    }
                }
            }

            # Ignore build issues
            if (![String]::IsNullOrEmpty($content)) {
                try {
                    $contentObject = $content | Out-String | ConvertFrom-Json;
                    $schema = $contentObject.'$schema'
                    $metadata = $contentObject.metadata
                    $hash = $metadata._generator.templateHash;
                    $scope = 'group'
                    if ($schema -like '*/subscriptionDeploymentTemplate.json*') {
                        $scope = 'sub'
                    }
                    if ($schema -like '*/tenantDeploymentTemplate.json*') {
                        $scope = 'tenant'
                    }
                    if ($Null -ne $metadata.mode) {
                        $mode = $metadata.mode;
                    }
                    if ($Null -ne $metadata.location) {
                        $location = $metadata.location;
                    }

                    if ($mode -eq 'deploy' -or $mode -eq 'whatif') {
                        $count++;
                        $whatIf = $mode -eq 'whatif';

                        if ($scope -eq 'group') {
                            Write-Warning -Message 'Deployment history is not supported for resource group deployments. Use targetScope = ''subscription''.';
                        }

                        Write-Host "Will include deployment in '$($mode)' mode for: $($_.FullName)" -ForegroundColor Cyan;
                        if ($scope -eq 'tenant') {
                            [PSCustomObject]@{
                                Name           = $name;
                                LandingZone    = $landingZoneName;
                                Path           = $_.FullName;
                                Hash           = $hash;
                                DeploymentName = "$name-deploy";
                                Scope          = $scope;
                                WhatIf         = $whatIf;
                                Location       = $location;
                            }
                        }
                        else {
                            [PSCustomObject]@{
                                Name           = $name;
                                LandingZone    = $landingZoneName;
                                Path           = $_.FullName;
                                Hash           = $hash;
                                DeploymentName = "$name-deploy";
                                SubscriptionId = "$($Subscription[$landingZoneName])";
                                Scope          = $scope;
                                WhatIf         = $whatIf;
                                Location       = $location;
                            }
                        }
                    }
                }
                catch {
                    Write-Error -Message "Failed to process deployment content for $($_.FullName): $content";
                }
            }
        }
    }
    end {
        if ($count -eq 0) {
            Write-Warning -Message "No deployments found.";
        }
    }
}

function Get-BuildAzureConfig {
    [CmdletBinding()]
    [OutputType([PSObject])]
    param ()
    end {
        return Get-Content -Path 'alz.config.json' -Raw | ConvertFrom-Json
    }
}

function Publish-AzureLandingZoneHierarchy {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $False)]
        [String]$Path = $PWD,

        [Parameter(Mandatory = $False)]
        [String]$DeploymentRoot = 'deployments/',

        [Parameter(Mandatory = $False)]
        [String[]]$Group,

        [Parameter(Mandatory = $False)]
        [String[]]$Include,

        [Parameter(Mandatory = $False)]
        [Switch]$SkipDeployment,

        [Parameter(Mandatory = $False)]
        [Switch]$WhatIf,

        [Parameter(Mandatory = $False)]
        [Switch]$Validate
    )
    begin {
        Write-Host "Using Path: $Path" -ForegroundColor Cyan;
        Write-Host "Using DeploymentRoot: $DeploymentRoot" -ForegroundColor Cyan;
        if ($Null -ne $Group) {
            Write-Host "Using Group: $([String]::Join(', ', $Group))" -ForegroundColor Cyan;
        }
    }
    process {

        # Get all deployments
        $deployments = Get-BicepDeployment -Path $Path -DeploymentRoot $DeploymentRoot -LandingZone $Group -Include $Include -Verbose:$VerbosePreference;

        Write-Host "Starting deployment" -ForegroundColor Cyan;

        $deployments | ForEach-Object -ThrottleLimit 10 -ErrorVariable Continue -Parallel {
            $deployment = $_;
            $additionalParams = '';
            $cmd = 'create'

            if ($Using:Validate) {
                $cmd = 'validate'
                Write-Host "Should use $($deployment.scope) for validate: $($deployment.Name)" -ForegroundColor Yellow;
            }
            elseif ($Using:WhatIf -or $deployment.WhatIf) {
                $cmd = 'what-if'
                Write-Host "Should use $($deployment.scope) for whatif: $($deployment.Name)" -ForegroundColor Yellow;
            }
            else {
                Write-Host "Should use $($deployment.scope) for deploy: $($deployment.Name)" -ForegroundColor Yellow;
            }

            if (!$Using:SkipDeployment) {
                if ($deployment.scope -eq 'sub') {
                    az deployment sub $cmd --location $deployment.location --name "$($deployment.DeploymentName)" --template-file "$($deployment.Path)" --subscription "$($deployment.SubscriptionId)" $additionalParams
                }
                elseif ($deployment.scope -eq 'tenant') {
                    az deployment tenant $cmd --location $deployment.location --name "$($deployment.DeploymentName)" --template-file "$($deployment.Path)" $additionalParams
                }
                elseif ($deployment.scope -eq 'group') {
                    az deployment group $cmd --resource-group "$($deployment.Name)" --name "$($deployment.DeploymentName)" --template-file "$($deployment.Path)" --subscription "$($deployment.SubscriptionId)" $additionalParams
                }
                else {
                    Write-Error -Message "Unknown deployment scope '$($deployment.scope)': $($deployment.DeploymentName)" -ErrorId 'BuildAzure.UnknownDeploymentScope';
                }
            }
        }
    }
}
