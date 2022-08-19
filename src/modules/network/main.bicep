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
        config.network.resources.properties.addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: config.network.resources.properties.subnet.addressPrefix
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
