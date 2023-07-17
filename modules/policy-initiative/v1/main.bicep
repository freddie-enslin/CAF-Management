// Create or update a Policy Initiative
targetScope = 'managementGroup'
metadata name = 'Policy Initiative'
metadata description = 'Create or update an Azure Policy initiative to enforce governance rules.'

// ----------
// PARAMETERS
// ----------

@sys.description('The name of the policy initiative.')
param name string = deployment().name

@sys.description('The display name of the policy initiative.')
param displayName string = name

@sys.description('Set the category of the policy initiative. The default category is `Governance`.')
param category string = ''

@sys.description('Set the version of the policy initiative.')
param version string = ''

@sys.description('Set to `true` of the policy in preview. Preview policies will use the `-preview` suffix to keep them separate from GA policies.')
param preview bool

@sys.description('Set to `true` if the policy initiative has been marked as _deprecated_.')
param deprecated bool = false

@sys.description('The purpose of the policy initiative.')
param description string = ''

@sys.description('Additional metadata to add to the initiative.')
param metadata object = {}

@sys.description('Define the body of the policy initiative.')
param content object

// ---------
// VARIABLES
// ---------

var properties = contains(content, 'properties') ? content.properties : {}
var actualDisplayName = !empty(displayName) ? displayName : contains(properties, 'displayName') ? properties.displayName : ''
var actualDescription = !empty(description) ? description : contains(properties, 'description') ? properties.description : ''
var actualVersion = !empty(version) ? version : contains(properties, 'metadata') && contains(properties.metadata, 'version') ? properties.metadata.version : ''
var actualCategory = !empty(category) ? category : contains(properties, 'metadata') && contains(properties.metadata, 'category') ? properties.metadata.category : 'Governance'

var commonMetadata = {
  category: actualCategory
  version: actualVersion
  preview: preview ? true : null
  deprecated: deprecated ? true : null
}

// ---------
// RESOURCES
// ---------

@sys.description('Create or update a Policy Initiative.')
resource initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = if (!preview) {
  name: name
  properties: {
    policyType: 'Custom'
    displayName: deprecated ? '[DEPRECATED]: ${actualDisplayName}' : actualDisplayName
    description: actualDescription
    metadata: union(
      commonMetadata,
      metadata,
      contains(properties, 'metadata') ? properties.metadata : {}
    )
    parameters: contains(properties, 'parameters') ? properties.parameters : {}
    policyDefinitions: properties.policyDefinitions
  }
}

// A separate deployment is used on purpose to fix parsing issue when referencing assignment.
@sys.description('Create or update a Policy Initiative as a preview.')
resource initiative_preview 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = if (preview) {
  name: '${name}-preview'
  properties: {
    policyType: 'Custom'
    displayName: deprecated ? '[DEPRECATED]: ${actualDisplayName}' : '[PREVIEW]: ${actualDisplayName}'
    description: actualDescription
    metadata: union(
      commonMetadata,
      metadata,
      contains(properties, 'metadata') ? properties.metadata : {}
    )
    parameters: contains(properties, 'parameters') ? properties.parameters : {}
    policyDefinitions: properties.policyDefinitions
  }
}

// -------
// OUTPUTS
// -------

@sys.description('A unique identifier for the Policy Initiative.')
output id string = preview ? initiative_preview.id : initiative.id
