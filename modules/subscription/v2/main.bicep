// Create new Subscription
targetScope = 'managementGroup'

// ----------
// PARAMETERS
// ----------

@sys.description('Existing subscription ID if it exists')
param existingSubscriptionId string = ''

@sys.description('The billing scope for the new Subscription')
param subscriptionBillingScope string

@sys.description('The name of the subscription alias')
param subscriptionAliasName string = deployment().name

@sys.description('The name of the subscription')
param subscriptionDisplayName string = subscriptionAliasName

@sys.description('The workload type')
@allowed([
  'DevTest'
  'Production'
])
param subscriptionWorkload string = 'Production'

@sys.description('management Group for subscription placement')
param subscriptionManagementGroupId string = tenant().tenantId

@sys.description('Configure tags for the subscription')
param tags object = {}

@metadata({
  example: [
    {
      principalId: 'OBJECT_ID'
      description: 'DESCRIPTION'
      principalType: 'Group'
      role: 'Contributor'
    }
  ]
})
@sys.description('A list of additional role assignements for the subscription')
param assignments array = []

// ----------
// REFERENCES
// ----------

// -------
// MODULES
// -------

module createSubscription '.bicep/subscription.alias.bicep' = if (empty(existingSubscriptionId)) {
  scope: managementGroup()
  name: 'createSubscription-${subscriptionAliasName}'
  params: {
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: subscriptionAliasName
    subscriptionDisplayName: subscriptionDisplayName
    subscriptionWorkload: subscriptionWorkload
  }
}

module configureSubscription '.bicep/subscription.configuration.bicep' = {
  name: 'configureSubscription-${uniqueString(toLower(subscriptionAliasName), toLower(subscriptionManagementGroupId))}'
  params: {
    subscriptionId: !empty(existingSubscriptionId) ? existingSubscriptionId : '${createSubscription.outputs.subscriptionId}'
    subscriptionManagementGroupId: subscriptionManagementGroupId
    tags: tags
    assignments: assignments
  }
}

// -------
// OUTPUTS
// -------

@sys.description('A unique identifier for the subscription')
output id string = createSubscription.outputs.id

@sys.description('The guid for the deployed subscription.')
output subscriptionId string = createSubscription.outputs.subscriptionId
