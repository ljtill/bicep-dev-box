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
    config: config
  }
}

// Network
module network './modules/network/main.bicep' = {
  name: 'Microsoft.Network'
  scope: resourceGroup(config.network.resourceGroup.name)
  params: {
    config: config
  }
  dependsOn: [
    resources
  ]
}

// DevCenter
module devcenter 'modules/devcenter/main.bicep' = {
  name: 'Microsoft.DevCenter'
  scope: resourceGroup(config.devbox.resourceGroup.name)
  params: {
    config: config
  }
  dependsOn: [
    resources
    network
  ]
}

// ----------
// Parameters
// ----------

param config object = {}
