// Deployment for Azure Landing Zone hierarchy
targetScope = 'tenant'

// ----------
// REFERENCES
// ----------

// -----------------
// MANAGEMENT GROUPS
// -----------------

@sys.description('Create a management group within the Cloud Adoption Framework.')
module mg '../../../../modules/management-group/v1/main.bicep' = {
  name: 'mg-aip-dev'
  params: {
    displayName: 'Aurizon Integration Platform Development'
    parent: 'mg-aip'
  }
}

// -----------------
// POLICIES ENFORCED
// -----------------

// -------------------
// POLICIES IN PREVIEW
// -------------------

// -------------
// SUBSCRIPTIONS
// -------------
