// Unit tests for the parent module
targetScope = 'managementGroup'

// ----------
// REFERENCES
// ----------

// ---------
// RESOURCES
// ---------

@sys.description('Test a basic test.')
module sub_test '../main.bicep' = {
  name: 'sub-test'
  params: {
    subscriptionBillingScope: 'na'
    existingSubscriptionId: 'na'
  }
}
