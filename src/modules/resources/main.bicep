// ------
// Scopes
// ------

targetScope = 'subscription'

// ---------
// Resources
// ---------

resource network 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: config.network.resourceGroup.name
  location: config.location
  properties: {}
  tags: config.network.resources.tags
}

resource devbox 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: config.devbox.resourceGroup.name
  location: config.location
  properties: {}
  tags: config.devbox.resources.tags
}

// ----------
// Parameters
// ----------

param config object
