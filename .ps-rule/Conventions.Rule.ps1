# PSRule conventions for governance

#
# Policy initiatives
#

# Synopsis: Read policy initiative JSON content.
Export-PSRuleConvention 'Org.CheckPolicyInitiatives' -Initialize {
    $files = @(Get-ChildItem -Path 'policy/initiatives/' -Include '*.json' -Recurse -File)

    # Initiative definitions
    $definitions = @($files | ForEach-Object {
        $version = $_.Directory.Name
        $name = $_.Directory.Parent.Name
        $d = $PSRule.GetContentFirstOrDefault($_)
        $Null = $d | Add-Member -MemberType NoteProperty -Name 'Name' -Value "$name/$version"
        $d
    })
    $PSRule.ImportWithType('Microsoft.Authorization/policySetDefinitions', $definitions)

    # Initiative info
    $initiatives = @($files | ForEach-Object {
        $version = $_.Directory.Name
        $name = $_.Directory.Parent.Name
        [PSCustomObject]@{
            Name = $name
            Version = $version
            Path = $_.Directory.FullName
        }
    })
    $PSRule.ImportWithType('Azure.Policy.InitiativeInfo', $initiatives);
}

# Synopsis: All initaitives must have a corresponding README file.
Rule 'Org.InitiativeRequiresReadme' -Type 'Azure.Policy.InitiativeInfo' {
    $Assert.FilePath($TargetObject, 'Path', @('README.md'))
}

#
# Bicep modules
#

# Synopsis: Imports in Bicep module paths for analysis.
Export-PSRuleConvention 'Org.BicepModule' -Initialize {
    $modules = @(Get-ChildItem -Path 'modules/' -Include 'main.bicep' -Recurse -File | ForEach-Object {
        $version = $_.Directory.Name
        $name = $_.Directory.Parent.Name
        [PSCustomObject]@{
            Name = $name
            Version = $version
            Path = $_.Directory.FullName
        }
    })
    $PSRule.ImportWithType('Azure.Bicep.ModuleInfo', $modules);
}

# Synopsis: All modules must have a corresponding tests file.
Rule 'Org.BicepModuleRequiresTests' -Type 'Azure.Bicep.ModuleInfo' {
    $Assert.FilePath($TargetObject, 'Path', @('.tests/main.tests.bicep'))
}

# Synopsis: All modules must have a corresponding README file.
Rule 'Org.BicepModuleRequiresReadme' -Type 'Azure.Bicep.ModuleInfo' {
    $Assert.FilePath($TargetObject, 'Path', @('README.md'))
}

# Synopsis: All modules names must only include a-z and dash in their name.
Rule 'Org.BicepModuleName'  -Type 'Azure.Bicep.ModuleInfo' {
    $Assert.Match($TargetObject, 'name', '^[a-z-]{3,50}$', $True)
}

# Synopsis: All modules must be versioned with vN.
Rule 'Org.BicepModuleVersion'  -Type 'Azure.Bicep.ModuleInfo' {
    $Assert.Match($TargetObject, 'version', '^v[1-9][0-9]?$', $True)
}
