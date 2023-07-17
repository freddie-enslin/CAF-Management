// Unit tests for the parent module
targetScope = 'tenant'

// ----------
// REFERENCES
// ----------

// ---------
// RESOURCES
// ---------

@sys.description('Test a basic test.')
module test_basic '../main.bicep' = {
  name: 'mg-test'
  params: {
    parent: tenant().tenantId
  }
}
