// Configure RBAC role assignments
targetScope = 'subscription'

// ----------
// PARAMETERS
// ----------

@sys.description('The display name of the role to assign or the GUID.')
param role string

@sys.description('The GUID of the identity object to assign.')
param principalId string

@sys.description('A description of the assignment.')
param description string = ''

@allowed([
  'ServicePrincipal'
  'Group'
  'User'
  'ForeignGroup'
  'Device'
])
@sys.description('The principal type to assign.')
param principalType string = 'ServicePrincipal'

// ---------
// VARIABLES
// ---------

var roles = {
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Management Group Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5d58bcaf-24a5-4b20-bdb6-eed9f69fbe4c')
  'Management Group Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ac63b705-f282-497d-ac71-919bf39d939d')
  'Cost Management Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '434105ed-43f6-45c7-a02f-909b2ba83430')
  'Cost Management Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '72fafb9e-0641-4937-9268-a91bfd8191a3')
  'Security Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb1c8493-542b-48eb-b624-b4c8fea62acd')
  'Security Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '39bc4728-0917-49c7-9d2c-d95423bc2eb4')
  'Billing Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fa23ad8b-c56e-40d8-ac0c-ce449e1d2c64')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Support Request Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'cfd33db0-3dd1-45e3-aa9d-cdbdf3b6f24e')
}
var roleDefinitionId = contains(roles, role) ? roles[role] : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role)

// ---------
// RESOURCES
// ---------

@sys.description('Assign permissions to an Azure AD principal.')
resource rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(toLower(subscription().subscriptionId), toLower(principalId), toLower(roleDefinitionId))
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    principalType: principalType
    description: description
  }
}
