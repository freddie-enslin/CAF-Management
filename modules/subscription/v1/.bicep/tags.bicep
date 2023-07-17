// Configure subscription tags.
targetScope = 'subscription'

// ----------
// PARAMETERS
// ----------

@sys.description('Apply tags to the subscription.')
param tags object

// ---------
// VARIABLES
// ---------

// ---------
// RESOURCES
// ---------

@sys.description('Assign tags for the subscription.')
resource tagging 'Microsoft.Resources/tags@2022-09-01' = {
  scope: subscription()
  name: 'default'
  properties: {
    tags: tags
  }
}
