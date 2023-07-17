// Deployment for Azure Landing Zone hierarchy
targetScope = 'tenant'

// ----------
// REFERENCES
// ----------

@description('Set the billing scope to be used for deploying new subscriptions.')
resource billingScope 'Microsoft.Billing/billingAccounts/enrollmentAccounts@2019-10-01-preview' existing = {
  name: '64775321/170996'
}

// -----------------
// MANAGEMENT GROUPS
// -----------------

@sys.description('Create a management group within the Cloud Adoption Framework.')
module mg '../../../modules/management-group/v1/main.bicep' = {
  name: 'mg-management'
  params: {
    displayName: 'Management'
    parent: 'mg-platform'
  }
}

// -----------------
// POLICIES ENFORCED
// -----------------

// -------------------
// POLICIES IN PREVIEW
// -------------------

// -------------
// SUBSCRIPTIONS
// -------------

// @description('Deploy IaC shared subscription.')
// module sub_iac_prd_01 '../../../modules/subscription/v1/main.bicep' = {
//  scope: managementGroup(mg.name)
//  name: 'sub-iac-prd-01'
//  params: {
//    billingScope: billingScope.id
//    managementGroup: mg.name
//    tags: {
//      businessGroupinfrastructure: 'infrastructure'
//      businessOwner: 'arn.nguyen@aurizon.com.au'
//      costCentre: 'infrastructure'
//      technicalContact: 'infrastructure@aurizon.com.au'
//    }
//
//    assignments: [
//      {
//        principalId: '31bbc71f-7466-4532-92fe-277ef70664fe'
//        description: 'Grant permissions for deployments from azure-core-platform GitHub Actions.'
//        principalType: 'ServicePrincipal'
//        role: 'Owner'
//      }
//    ]
//  }
//}

@sys.description('Deploy management subscription')
module sub_mgt_prd_001 '../../../modules/subscription/v2/main.bicep' = {
  scope: managementGroup(mg.name)
  name: 'sub-mgt-prd-001-deploy'
  params: {
    subscriptionAliasName: 'sub-mgt-prd-001'

    subscriptionBillingScope: billingScope.id
    subscriptionManagementGroupId: mg.name
    tags: {
      businessOwner: 'arn.nguyen@aurizon.com.au'
      businessGroup: 'infrastructure'
      costCentre: 'infrastructure'
      environment: 'prd'
      technicalContact: 'infrastructure@aurizon.com.au'
      technicalGroup: 'infrastructure'
      sourceCode: 'github.com/aurizon/azure-governance'
    }
    assignments: [
      {
        principalId: '31bbc71f-7466-4532-92fe-277ef70664fe'
        description: 'Grant permissions for deployments from azure-core-platform GitHub Actions.'
        principalType: 'ServicePrincipal'
        role: 'Owner'
      }
    ]
  }
}
