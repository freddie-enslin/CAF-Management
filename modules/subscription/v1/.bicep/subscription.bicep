// Configure subscription.
targetScope = 'managementGroup'

// ----------
// PARAMETERS
// ----------

@sys.description('Apply tags to the subscription.')
param tags object

@sys.description('Any additional assignments for the subscription.')
param assignments array

@sys.description('The GUID for the subscription.')
param subscriptionId string

@sys.description('Specifies the name of the management group where the subscription will be linked to.')
param managementGroup string

@sys.description('Get a reference to the management group where the subscription will be deployed.')
resource mg 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  scope: tenant()
  name: managementGroup
}

// ---------
// VARIABLES
// ---------

@sys.description('Move the subscription to the parent management group.')
resource moveSubscription 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = if (!empty(subscriptionId)) {
  parent: mg
  name: subscriptionId
}

@sys.description('Configure tags for a subscription.')
module tagging 'tags.bicep' = {
  scope: subscription(subscriptionId)
  name: 'tagging'
  params: {
    tags: tags
  }
}

@sys.description('Create or update role assignments for the subscription.')
module rbac 'rbac.bicep' = [for assignment in assignments: {
  scope: subscription(subscriptionId)
  name: 'assignment-${uniqueString(toLower(subscriptionId), toLower(assignment.principalId), toLower(assignment.role))}'
  params: {
    principalId: assignment.principalId
    description: contains(assignment, 'description') ? assignment.description : ''
    principalType: assignment.principalType
    role: assignment.role
  }
}]

// -------
// OUTPUTS
// -------

@sys.description('The guid for the deployed subscription.')
output subscriptionId string = subscriptionId
