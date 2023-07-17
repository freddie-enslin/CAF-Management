// Configure subscription
targetScope = 'managementGroup'

// ----------
// PARAMETERS
// ----------

@sys.description('Tags to apply to the subscription')
param tags object

@sys.description('The GUID for the subscription')
param subscriptionId string

@sys.description('Any additional assignments for the subscription')
param assignments array

@sys.description('Management group for subscription placement')
param subscriptionManagementGroupId string = ''

// -------
// MODULES
// -------

module placeSubscription './managementGroup.location.bicep' = if (!empty(subscriptionManagementGroupId)) {
  scope: managementGroup(subscriptionManagementGroupId)
  name: 'placeSubscription-${deployment().name}'
  params: {
    subscriptionManagementGroupId: subscriptionManagementGroupId
    subscriptionId: subscriptionId
  }
}

module tagging 'tags.bicep' = {
  scope: subscription(subscriptionId)
  name: 'tagging'
  params: {
    tags: tags
  }
}

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

@sys.description('The GUID for the deployed subscription')
output subscriptionId string = subscriptionId
