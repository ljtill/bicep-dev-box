// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// ---------
// Resources
// ---------

// Virtual Network
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: config.network.resources.name
  location: config.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: securityGroup.id
          }
        }
      }
    ]
  }
  tags: config.network.resources.tags
}

// Security Group
resource securityGroup 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: config.network.resources.name
  location: config.location
  properties: {
    securityRules: []
  }
  tags: config.network.resources.tags
}

// ----------
// Parameters
// ----------

param config object
