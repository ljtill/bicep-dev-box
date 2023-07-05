// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// ---------
// Resources
// ---------

// Managed Identity
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: devcenterSettings.resources.managedIdentity.name
  location: devcenterSettings.resourceGroup.location
  tags: devcenterSettings.tags
}

// Compute Gallery
resource computeGallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: devcenterSettings.resources.computeGallery.name
  location: devcenterSettings.resourceGroup.location
  properties: {}
  tags: devcenterSettings.tags
}

// Network Connection
resource networkConnection 'Microsoft.DevCenter/networkConnections@2023-04-01' = {
  name: devcenterSettings.resources.networkConnection.name
  location: devcenterSettings.resourceGroup.location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: virtualNetwork.properties.subnets[0].id
    networkingResourceGroupName: 'Interface' // TMP
  }
  tags: devcenterSettings.tags
}

// DevCenter
resource devcenter 'Microsoft.DevCenter/devcenters@2023-04-01' = {
  name: devcenterSettings.resources.devcenter.name
  location: devcenterSettings.resourceGroup.location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {}
  tags: devcenterSettings.tags
}

// DevCenter Attached Networks
resource attachedNetworks 'Microsoft.DevCenter/devcenters/attachednetworks@2023-04-01' = {
  parent: devcenter
  name: 'default'
  properties: {
    networkConnectionId: networkConnection.id
  }
}

// DevCenter Galleries
// FIX(26): TemplateDeploymentValidationFailed
// resource galleries 'Microsoft.DevCenter/devcenters/galleries@2023-04-01' = {
//   parent: devcenter
//   name: devcenterSettings.resources.computeGallery.name
//   properties: {
//     galleryResourceId: computeGallery.id
//   }
// }

// DevCenter Definitions
resource definitions 'Microsoft.DevCenter/devcenters/devboxdefinitions@2023-04-01' = [for definition in devcenterSettings.resources.definitions: {
  parent: devcenter
  name: definition.name
  location: devcenterSettings.resourceGroup.location
  properties: {
    imageReference: {
      id: '${devcenter.id}/galleries/default/images/${image[definition.image]}'
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
resource project 'Microsoft.DevCenter/projects@2023-04-01' = {
  name: devcenterSettings.resources.projects.name
  location: devcenterSettings.resourceGroup.location
  properties: {
    devCenterId: devcenter.id
    description: devcenterSettings.resources.projects.description
  }
  resource pools 'pools' = [for pool in devcenterSettings.resources.projects.pools: {
    name: pool.name
    location: devcenterSettings.resourceGroup.location
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
  tags: devcenterSettings.tags
}

// ---------
// Resources
// ---------

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: networkSettings.resources.virtualNetwork.name
  scope: resourceGroup(networkSettings.resourceGroup.name)
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

param networkSettings object
param devcenterSettings object
