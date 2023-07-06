
$name = -join ((97..122) | Get-Random -Count 8 | % { [char]$_ })
$content = Get-Content "./src/parameters/main.json" | ConvertFrom-Json -Depth 25

# Network

$content.parameters.networkSettings.value.resourceGroup.name = "network-$env:GITHUB_RUN_ID-powershell"
$content.parameters.networkSettings.value.resources.virtualNetwork.name = "$name"
$content.parameters.networkSettings.value.resources.securityGroup.name = "$name"

# Compute

$content.parameters.computeSettings.value.resourceGroup.name = "compute-$env:GITHUB_RUN_ID-powershell"
$content.parameters.computeSettings.value.resources.galleries[0].name = "$name"

# Identity

$content.parameters.identitySettings.value.resourceGroup.name = "identity-$env:GITHUB_RUN_ID-powershell"
$content.parameters.identitySettings.value.resources.managedIdentity.name = "$name"

# DevCenter

$content.parameters.devcenterSettings.value.resourceGroup.name = "devbox-$env:GITHUB_RUN_ID-powershell"
$content.parameters.devcenterSettings.value.resources.networkConnection.name = "$name"
$content.parameters.devcenterSettings.value.resources.networkConnection.resourceGroup = "interface-$env:GITHUB_RUN_ID-powershell"
$content.parameters.devcenterSettings.value.resources.devcenter.name = "$name"

$content | ConvertTo-Json -Depth 25 | Out-File "./src/parameters/main.json"
