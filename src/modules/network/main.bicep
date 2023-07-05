// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// ---------
// Resources
// ---------

// Virtual Network
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: networkSettings.resources.virtualNetwork.name
  location: networkSettings.resourceGroup.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        networkSettings.resources.virtualNetwork.addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: networkSettings.resources.virtualNetwork.subnet.addressPrefix
          networkSecurityGroup: {
            id: securityGroup.id
          }
        }
      }
    ]
  }
  tags: networkSettings.tags
}

// Security Group
resource securityGroup 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: networkSettings.resources.securityGroup.name
  location: networkSettings.resourceGroup.location
  properties: {
    securityRules: []
  }
  tags: networkSettings.tags
}

// ----------
// Parameters
// ----------

param networkSettings object
