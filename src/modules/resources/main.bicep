// ------
// Scopes
// ------

targetScope = 'subscription'

// ---------
// Resources
// ---------

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = [for resourceGroup in resourceGroups: {
  name: resourceGroup.name
  location: resourceGroup.location
  properties: {}
  tags: resourceGroup.tags
}]

// ----------
// Parameters
// ----------

param resourceGroups array
