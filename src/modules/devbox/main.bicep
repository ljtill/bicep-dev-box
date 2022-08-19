// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// ---------
// Resources
// ---------

// Managed Identity
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: config.devbox.resources.name
  location: config.location
  tags: config.devbox.resources.tags
}

// Compute Gallery
// TODO: Disabled due to validation error
// resource computeGallery 'Microsoft.Compute/galleries@2021-07-01' = {
//   name: config.devbox.resources.name
//   location: config.location
//   properties: {}
//   tags: config.network.resources.tags
// }

// Network Connection
resource networkConnection 'Microsoft.DevCenter/networkconnections@2022-08-01-preview' = {
  name: config.devbox.resources.name
  location: config.location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: virtualNetwork.properties.subnets[0].id
    networkingResourceGroupName: 'Interfaces'
  }
  tags: config.devbox.resources.tags
}

// DevCenter
resource devCenter 'Microsoft.DevCenter/devcenters@2022-08-01-preview' = {
  name: config.devbox.resources.name
  location: config.location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {}
  tags: config.devbox.resources.tags
}

// DevCenter Attached Networks
resource attachedNetworks 'Microsoft.DevCenter/devcenters/attachednetworks@2022-08-01-preview' = {
  parent: devCenter
  name: 'default'
  properties: {
    networkConnectionId: networkConnection.id
  }
}

// DevCenter Galleries
// TODO: Disabled due to validation error
// resource galleries 'Microsoft.DevCenter/devcenters/galleries@2022-08-01-preview' = {
//   parent: devCenter
//   name: config.devbox.resources.name
//   properties: {
//     galleryResourceId: computeGallery.id
//   }
// }

// DevCenter Definitions
resource definitions 'Microsoft.DevCenter/devcenters/devboxdefinitions@2022-08-01-preview' = [for definition in config.devbox.resources.properties.definitions: {
  parent: devCenter
  name: definition.name
  location: config.location
  properties: {
    imageReference: {
      id: '${devCenter.id}/galleries/default/images/${image[definition.image]}'
    }
    sku: {
      name: compute[definition.compute]
    }
    osStorageType: storage[definition.storage]
  }
  dependsOn: [
    attachedNetworks
  ]
}]

// DevCenter Project
// TODO: Support multiple projects
resource project 'Microsoft.DevCenter/projects@2022-08-01-preview' = {
  name: config.devbox.resources.properties.project.name
  location: config.location
  properties: {
    devCenterId: devCenter.id
    description: config.devbox.resources.properties.project.description
  }
  resource pools 'pools' = [for pool in config.devbox.resources.properties.project.pools: {
    name: pool.name
    location: config.location
    properties: {
      devBoxDefinitionName: pool.definition
      networkConnectionName: 'default'
      licenseType: 'Windows_Client'
      localAdministrator: pool.administrator
    }
  }]
  dependsOn: [
    definitions
  ]
}

// ---------
// Resources
// ---------

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: config.network.resources.name
  scope: resourceGroup(config.network.resourceGroup.name)
}

// ---------
// Variables
// ---------

var image = {
  'win-11-ent-os-opt': 'microsoftwindowsdesktop_windows-ent-cpc_win11-21h2-ent-cpc-os'
  'win-11-ent-m365-apps': 'microsoftwindowsdesktop_windows-ent-cpc_win11-21h2-ent-cpc-m365'
}

var compute = {
  '4-vcpu-16gb-mem': 'general_a_4c16gb_v1'
  '8-vcpu-32gb-mem': 'general_a_8c32gb_v1'
}

var storage = {
  '256gb-ssd': 'ssd_256gb'
  '512gb-ssd': 'ssd_512gb'
  '1024gb-ssd': 'ssd_1024gb'
}

// ----------
// Parameters
// ----------

param config object
