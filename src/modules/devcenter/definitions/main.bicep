// ------
// Scopes
// ------

targetScope = 'resourceGroup'

// ---------
// Resources
// ---------

// Definitions
resource definitions 'Microsoft.DevCenter/devcenters/devboxdefinitions@2023-04-01' = [for definition in settings.resources.definitions: {
  parent: devcenter
  name: definition.name
  location: settings.resourceGroup.location
  properties: {
    imageReference: {
      id: '${devcenter.id}/galleries/default/images/${images[definition.image]}'
    }
    sku: {
      name: compute[definition.compute]
    }
    osStorageType: storage[definition.storage]
    hibernateSupport: 'Disabled'
  }
}]

// ---------
// Resources
// ---------

resource devcenter 'Microsoft.DevCenter/devcenters@2023-04-01' existing = {
  name: settings.resources.devcenter.name
}

// ---------
// Variables
// ---------

var images = {
  // Windows 10
  'win-10-ent-20h2-os': 'microsoftwindowsdesktop_windows-ent-cpc_20h2-ent-cpc-os-g2'
  'win-10-ent-20h2-m365': 'microsoftwindowsdesktop_windows-ent-cpc_20h2-ent-cpc-m365-g2'
  'win-10-ent-21h2-os': 'microsoftwindowsdesktop_windows-ent-cpc_win10-21h2-ent-cpc-os-g2'
  'win-10-ent-21h2-m365': 'microsoftwindowsdesktop_windows-ent-cpc_win10-21h2-ent-cpc-m365-g2'
  'win-10-ent-22h2-os': 'microsoftwindowsdesktop_windows-ent-cpc_win10-22h2-ent-cpc-os'
  'win-10-ent-22h2-m365': 'microsoftwindowsdesktop_windows-ent-cpc_win10-22h2-ent-cpc-m365'

  // Windows 11
  'win-11-ent-21h2-os': 'microsoftwindowsdesktop_windows-ent-cpc_win11-21h2-ent-cpc-os'
  'win-11-ent-21h2-m365': 'microsoftwindowsdesktop_windows-ent-cpc_win11-21h2-ent-cpc-m365'
  'win-11-ent-22h2-os': 'microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-os'
  'win-11-ent-22h2-m365': 'microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-m365'

  // Visual Studio 2019
  'vs-19-pro-win-10-m365': 'microsoftvisualstudio_visualstudio2019plustools_vs-2019-pro-general-win10-m365-gen2'
  'vs-19-ent-win-10-m365': 'microsoftvisualstudio_visualstudio2019plustools_vs-2019-ent-general-win10-m365-gen2'
  'vs-19-pro-win-11-m365': 'microsoftvisualstudio_visualstudio2019plustools_vs-2019-pro-general-win11-m365-gen2'
  'vs-19-ent-win-11-m365': 'microsoftvisualstudio_visualstudio2019plustools_vs-2019-ent-general-win11-m365-gen2'

  // Visual Studio 2022
  'vs-22-pro-win-10-m365': 'microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win10-m365-gen2'
  'vs-22-ent-win-10-m365': 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win10-m365-gen2'
  'vs-22-pro-win-11-m365': 'microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win11-m365-gen2'
  'vs-22-ent-win-11-m365': 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
}

var compute = {
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

param settings object
