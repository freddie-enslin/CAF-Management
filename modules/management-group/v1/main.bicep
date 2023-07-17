// Create or update a Management Group
targetScope = 'tenant'
metadata name = 'Management Group'
metadata description = 'Create or update and management group to the specified parent management group.'

// ----------
// PARAMETERS
// ----------

@sys.description('The name of the Management Group.')
param name string = deployment().name

@sys.description('The display name of the Management Group.')
param displayName string = name

@sys.description('Specifies the name of the parent management group.')
param parent string

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
@sys.description('A list of additional role assignments for the Management Group.')
param assignments array = []

// ----------
// REFERENCES
// ----------

@sys.description('A reference to the parent resource group.')
resource mg 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: parent
}

// ---------
// RESOURCES
// ---------

@sys.description('Create or update a Management Group.')
resource group 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: name
  properties: {
    displayName: displayName
    details: {
      parent: {
        id: mg.id
      }
    }
  }
}

@sys.description('Create or update role assignments for the management group.')
module rbac '.bicep/rbac.bicep' = [for assignment in assignments: {
  scope: group
  name: 'assignment-${uniqueString(toLower(group.id), toLower(assignment.principalId), toLower(assignment.role))}'
  params: {
    principalId: assignment.principalId
    description: contains(assignment, 'description') ? assignment.description : ''
    principalType: assignment.principalType
    role: assignment.role
    resourceName: group.name
  }
}]

// -------
// OUTPUTS
// -------

@sys.description('A unique identifier for the Management Group.')
output id string = group.id
