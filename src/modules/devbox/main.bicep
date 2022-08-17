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
resource definitions 'Microsoft.DevCenter/devcenters/devboxdefinitions@2022-08-01-preview' = [for (image, count) in images: {
  parent: devCenter
  name: 'definition-${count}'
  location: config.location
  properties: {
    imageReference: {
      id: '${devCenter.id}/galleries/default/images/${image}'
    }
    sku: {
      name: compute[0]
    }
    osStorageType: storage[0]
  }
}]

// DevCenter Project
resource project 'Microsoft.DevCenter/projects@2022-08-01-preview' = {
  name: 'default'
  location: config.location
  properties: {
    devCenterId: devCenter.id
    description: ''
  }
}

// DevCenter Project Pool
resource projectPools 'Microsoft.DevCenter/projects/pools@2022-08-01-preview' = [for count in range(0, length(images)): {
  parent: project
  name: pools[count]
  location: config.location
  properties: {
    devBoxDefinitionName: 'definition-${count}'
    networkConnectionName: 'default'
    licenseType: 'Windows_Client'
    localAdministrator: 'Enabled'
  }
}]

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

var images = [
  // Windows 11 Enterprise + OS Optimizations 21H2
  'microsoftwindowsdesktop_windows-ent-cpc_win11-21h2-ent-cpc-os'
  // Windows 11 Enterprise + Microsoft 365 Apps 21H2
  'microsoftwindowsdesktop_windows-ent-cpc_win11-21h2-ent-cpc-m365'
]

var pools = [
  'Win-11-OS'
  'Win-11-M365'
]

var compute = [
  // 4 vCPU + 16 GB RAM
  'general_a_4c16gb_v1'
  // 8 vCPU + 32 GB RAM
  'general_a_8c32gb_v1'
]

var storage = [
  // 256 GB SSD
  'ssd_256gb'
  // 512 GB SSD
  'ssd_512gb'
  // 1024 GB SSD
  'ssd_1024gb'
]

// ----------
// Parameters
// ----------

param config object
