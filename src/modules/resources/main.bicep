// ------
// Scopes
// ------

targetScope = 'subscription'

// ---------
// Resources
// ---------

resource network 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: networkSettings.resourceGroup.name
  location: networkSettings.resourceGroup.location
  properties: {}
  tags: networkSettings.tags
}

resource devcenter 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: devcenterSettings.resourceGroup.name
  location: devcenterSettings.resourceGroup.location
  properties: {}
  tags: devcenterSettings.tags
}

// ----------
// Parameters
// ----------

param networkSettings object
param devcenterSettings object
