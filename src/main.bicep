// ------
// Scopes
// ------

targetScope = 'subscription'

// -------
// Modules
// -------

// Resources
module resources './modules/resources/main.bicep' = {
  name: 'Microsoft.Resources'
  scope: subscription()
  params: {
    networkSettings: networkSettings
    devcenterSettings: devcenterSettings
  }
}

// Network
module network './modules/network/main.bicep' = {
  name: 'Microsoft.Network'
  scope: resourceGroup(networkSettings.resourceGroup.name)
  params: {
    networkSettings: networkSettings
  }
  dependsOn: [
    resources
  ]
}

// DevCenter
module devcenter 'modules/devcenter/main.bicep' = {
  name: 'Microsoft.DevCenter'
  scope: resourceGroup(devcenterSettings.resourceGroup.name)
  params: {
    networkSettings: networkSettings
    devcenterSettings: devcenterSettings
  }
  dependsOn: [
    resources
    network
  ]
}

// ----------
// Parameters
// ----------

param networkSettings object
param devcenterSettings object
