
$name = -join ((97..122) | Get-Random -Count 8 | % { [char]$_ })
$content = Get-Content "./src/configs/main.json" | ConvertFrom-Json -Depth 25

# Network

$content.parameters.networkSettings.value.resourceGroup.name = "network-$env:GITHUB_RUN_ID-powershell"
$content.parameters.networkSettings.value.resourceGroup.location = "uksouth"
$content.parameters.networkSettings.value.resources.virtualNetwork.name = "$name"
$content.parameters.networkSettings.value.resources.securityGroup.name = "$name"

# DevCenter

$content.parameters.config.value.devbox.resourceGroup.name = "devbox-$env:GITHUB_RUN_ID-powershell"
$content.parameters.config.value.devbox.resourceGroup.name = "uksouth"
$content.parameters.config.value.devbox.resources.managedIdentity.name = "$name"
$content.parameters.config.value.devbox.resources.computeGallery.name = "$name"
$content.parameters.config.value.devbox.resources.networkConnection.name = "$name"
$content.parameters.config.value.devbox.resources.devcenter.name = "$name"
$content.parameters.config.value.devbox.resources.projects.name = "$name"
$content.parameters.config.value.devbox.resources.projects.description = "Deployed by GitHub Actions"
$content.parameters.config.value.devbox.resources.projects.pools[0].name = "$name"

$content | ConvertTo-Json -Depth 25 | Out-File "./src/configs/main.json"
