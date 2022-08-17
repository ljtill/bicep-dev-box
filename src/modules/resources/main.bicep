// ------
// Scopes
// ------

targetScope = 'subscription'

// ---------
// Resources
// ---------

resource network 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: config.network.resourceGroup
  location: config.location
  properties: {}
  tags: tags
}

resource desktop 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: config.desktops.resourceGroup
  location: config.location
  properties: {}
  tags: tags
}

// ----------
// Parameters
// ----------

param config object
param tags object = {}
