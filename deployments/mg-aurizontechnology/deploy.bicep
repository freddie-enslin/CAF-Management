// Deployment for Azure Landing Zone hierarchy
targetScope = 'tenant'

// -----------------
// MANAGEMENT GROUPS
// -----------------

@sys.description('Create top Aurizon management group for Cloud Adoption Framework.')
module mg '../../modules/management-group/v1/main.bicep' = {
  name: 'mg-aurizontechnology'
  params: {
    displayName: 'Aurizon Technology'
    parent: tenant().tenantId
  }
}

// -----------------
// POLICIES ENFORCED
// -----------------

// -------------------
// POLICIES IN PREVIEW
// -------------------

@sys.description('Create global initiative for compliance.')
module aurizon_global '../../modules/policy-initiative/v1/main.bicep' = {
  scope: managementGroup(mg.name)
  name: 'aurizon-global'
  params: {
    preview: true
    content: loadJsonContent('../../policy/initiatives/global/v1/initiative.json')
  }
}

@sys.description('Assign the global initiative.')
module aurizon_global_assignment '../../modules/policy-initiative-assignment/v1/main.bicep' = {
  scope: managementGroup(mg.name)
  name: 'aurizon-global-assignment'
  params: {
    enforced: false
    policyDefinitionId: aurizon_global.outputs.id
  }
}

@sys.description('Create initiative for API compliance.')
module api '../../modules/policy-initiative/v1/main.bicep' = {
  scope: managementGroup(mg.name)
  name: 'api'
  params: {
    preview: true
    content: loadJsonContent('../../policy/initiatives/api/v1/initiative.json')
  }
}

@sys.description('Create initiative for app compliance.')
module app '../../modules/policy-initiative/v1/main.bicep' = {
  scope: managementGroup(mg.name)
  name: 'app'
  params: {
    preview: true
    content: loadJsonContent('../../policy/initiatives/app/v1/initiative.json')
  }
}

@sys.description('Create initiative for Databricks compliance.')
module databricks '../../modules/policy-initiative/v1/main.bicep' = {
  scope: managementGroup(mg.name)
  name: 'databricks'
  params: {
    preview: true
    content: loadJsonContent('../../policy/initiatives/databricks/v1/initiative.json')
  }
}
