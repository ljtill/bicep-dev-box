// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// ---------
// Resources
// ---------

// Environment Types
resource environmentType 'Microsoft.DevCenter/devcenters/environmentTypes@2023-04-01' = [for environment in settings.resources.environments: {
  parent: devcenter
  name: environment.name
  properties: {}
  tags: environment.tags
}]

// ---------
// Resources
// ---------

resource devcenter 'Microsoft.DevCenter/devcenters@2023-04-01' existing = {
  name: settings.resources.devcenter.name
}

// ----------
// Parameters
// ----------

param settings object
