targetScope = 'managementGroup'

// ----------
// PARAMETERS
// ----------

@sys.description('The name of the subscription alias')
param subscriptionDisplayName string

@sys.description('The name of the subscription alias')
param subscriptionAliasName string

@sys.description('The billing scope for the new subscription alias')
param subscriptionBillingScope string

@allowed([
  'DevTest'
  'Production'
])
@sys.description('The workload type can be either `Production` or `DevTest`')
param subscriptionWorkload string = 'Production'

// ---------
// Resources
// ---------

resource subscriptionAlias 'Microsoft.Subscription/aliases@2021-10-01' = {
  scope: tenant()
  name: subscriptionAliasName
  properties: {
    workload: subscriptionWorkload
    displayName: subscriptionDisplayName
    billingScope: subscriptionBillingScope
  }
}

// -------
// OUTPUTS
// -------

output subscriptionId string = subscriptionAlias.properties.subscriptionId
output subscriptionResourceId string = '/subscriptions/${subscriptionAlias.properties.subscriptionId}'
output id string = subscriptionAlias.id
