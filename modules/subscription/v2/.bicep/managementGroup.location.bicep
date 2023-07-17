targetScope = 'managementGroup'

// ----------
// PARAMETERS
// ----------

@sys.description('The destination management group ID for the new subscription')
param subscriptionManagementGroupId string

@sys.description('The ID of the subscription to move to the target management group')
param subscriptionId string

// ---------
// RESOURCES
// ---------

resource existingManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  scope: tenant()
  name: subscriptionManagementGroupId
}

resource managementGroupSubscriptionAssociation 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = {
  parent: existingManagementGroup
  name: subscriptionId
}
