// Deployment for Azure Landing Zone hierarchy
targetScope = 'tenant'

// ----------
// REFERENCES
// ----------

// @description('Set the billing scope to be used for deploying new subscriptions.')
// resource billingScope 'Microsoft.Billing/billingAccounts/enrollmentAccounts@2019-10-01-preview' existing = {
//   name: '64775321/170996'
// }

// -----------------
// MANAGEMENT GROUPS
// -----------------

@sys.description('Create a management group within the Cloud Adoption Framework.')
module mg '../../../modules/management-group/v1/main.bicep' = {
  name: 'mg-connectivity'
  params: {
    displayName: 'Connectivity'
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

@description('Deploy connectivity subscription.')
module sub_con_prd_01 '../../../modules/subscription/v1/main.bicep' = {
  scope: managementGroup(mg.name)
  name: 'sub-con-prd-01'
  params: {
    billingScope: '/providers/Microsoft.Billing/billingAccounts/64775321/enrollmentAccounts/170996'
    managementGroup: mg.name
    subscriptionId: 'e923c1a8-35aa-4ad8-ac87-dc2fdece7316'
    tags: {
      businessGroupinfrastructure: 'infrastructure'
      businessOwner: 'stephen.leach@aurizon.com.au'
      costCentre: 'infrastructure'
      technicalContact: 'infrastructure@aurizon.com.au'
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
