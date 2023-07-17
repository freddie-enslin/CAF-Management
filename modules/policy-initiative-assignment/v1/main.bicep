// Create or update a Policy Initiative assignment
targetScope = 'managementGroup'
metadata name = 'Policy Initiative assignment'
metadata description = 'Assign a policy initiative at a management group scope.'

// ----------
// PARAMETERS
// ----------

@sys.description('The name of the assignment.')
param name string = deployment().name

@sys.description('The display name of the assignment. By default this will be the name of the assignment.')
param displayName string = name

@sys.description('An additional description for the assignment.')
param description string = ''

@sys.description('Set the category of the assignment.')
param category string = 'Governance'

@sys.description('The resource Id for the initiative that will be assigned to the scope.')
param policyDefinitionId string

@sys.description('Determines if the assignment is enforced.')
param enforced bool

@sys.description('The assigner that will be reported by Azure Policy.')
param assignedBy string = 'DevOps deployment'

@sys.description('Any excluded scopes for the assignment.')
param excludedScopes array = []

@sys.description('Any additional parameters that are required by the assignment.')
param parameters object = {}

@sys.description('Additional metadata to add to the assignment.')
param metadata object = {}

// ---------
// VARIABLES
// ---------

var commonMetadata = {
  assignedBy: assignedBy
  category: category
}

// ---------
// RESOURCES
// ---------

@sys.description('Create or update an assignment.')
resource assignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: take(guid(toLower(name), toLower(policyDefinitionId)), 23)
  properties: {
    displayName: displayName
    description: !empty(description) ? description : reference(policyDefinitionId, '2021-06-01').description
    enforcementMode: enforced ? 'Default' : 'DoNotEnforce'
    metadata: union(commonMetadata, metadata)
    notScopes: excludedScopes
    policyDefinitionId: policyDefinitionId
    parameters: parameters
  }
}

// -------
// OUTPUTS
// -------

@sys.description('A unique identifier for the Policy Initiative assignment.')
output id string = assignment.id
