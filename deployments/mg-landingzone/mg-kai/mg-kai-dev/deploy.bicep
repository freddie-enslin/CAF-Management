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
  name: 'mg-kai-dev'
  params: {
    displayName: 'Kaiseki Development'
    parent: 'mg-kai'
  }
}

// -----------------
// POLICIES ENFORCED
// -----------------

// -------------------
// POLICIES IN PREVIEW
// -------------------
