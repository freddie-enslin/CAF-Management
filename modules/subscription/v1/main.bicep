// Create or update a Subscription
targetScope = 'managementGroup'
// metadata name = 'Subscription'
metadata description = 'Create or update a subscription.'

// ----------
// PARAMETERS
// ----------

@sys.description('The name of the subscription.')
param name string = deployment().name

@sys.description('The display name of the subscription.')
param displayName string = name

@allowed([
  'DevTest'
  'Production'
])
@sys.description('The workload type can be either `Production` or `DevTest` and is case sensitive.')
param workloadType string = 'Production'

@sys.description('Specifies the name of the management group where the subscription will be linked to.')
param managementGroup string = tenant().tenantId

@sys.description('The billing scope for the subscription.')
param billingScope string

@sys.description('The GUID if the subscription already exists.')
param subscriptionId string = ''

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
@sys.description('A list of additional role assignments for the subscription.')
param assignments array = []

@sys.description('Apply tags to the subscription.')
param tags object = {}

// ----------
// REFERENCES
// ----------

@sys.description('Get a reference to the management group where the subscription will be deployed.')
resource mg 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  scope: tenant()
  name: managementGroup
}

// ---------
// RESOURCES
// ---------

@sys.description('Create or update a subscription.')
resource alias 'Microsoft.Subscription/aliases@2021-10-01' = if (empty(subscriptionId)) {
  scope: tenant()
  name: name
  properties: {
    workload: workloadType
    displayName: displayName
    billingScope: billingScope
  }
}

@sys.description('Create or update role assignments for the subscription.')
module subscription '.bicep/subscription.bicep' = {
  scope: mg
  name: 'subscription-${toLower(name)}'
  params: {
    managementGroup: managementGroup
    tags: tags
    assignments: assignments
    subscriptionId: !empty(subscriptionId) ? subscriptionId : '${alias.properties.subscriptionId}'
  }
}

// -------
// OUTPUTS
// -------

@sys.description('A unique identifier for the subscription.')
output id string = alias.id

@sys.description('The guid for the deployed subscription.')
output subscriptionId string = subscription.outputs.subscriptionId
