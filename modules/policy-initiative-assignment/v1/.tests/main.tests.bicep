// Unit tests for the parent module
targetScope = 'managementGroup'

// ----------
// REFERENCES
// ----------

@sys.description('A test initiative.')
resource test_initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' existing = {
  name: 'test-initiative'
}

// ---------
// RESOURCES
// ---------

@sys.description('Test a basic test.')
module test_basic '../main.bicep' = {
  name: 'test_basic'
  params: {
    enforced: false
    policyDefinitionId: test_initiative.id
  }
}
