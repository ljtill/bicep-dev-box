// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// ---------
// Resources
// ---------

// Virtual Network
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: settings.resources.virtualNetwork.name
  location: settings.resourceGroup.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        settings.resources.virtualNetwork.addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: settings.resources.virtualNetwork.subnet.addressPrefix
          networkSecurityGroup: {
            id: securityGroup.id
          }
        }
      }
    ]
  }
}

// Security Group
resource securityGroup 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: settings.resources.securityGroup.name
  location: settings.resourceGroup.location
  properties: {
    securityRules: []
  }
}

// ----------
// Parameters
// ----------

param settings object

// -------
// Outputs
// -------

output subnetId string = virtualNetwork.properties.subnets[0].id
