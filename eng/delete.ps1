<#
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    $SubscriptionId,

    [Parameter(Mandatory = $false)]
    $ConfigFile = $PSScriptRoot + "../src/configs/main.json"
)

$ErrorActionPreference = 'Stop'

Write-Verbose "Switching subscriptions"
try {
    Set-AzContext -SubscriptionId $SubscriptionId
}
catch {
    Write-Error "Failed to switch subscriptions"
    Exit-PSSession 1
}

Write-Verbose "Parsing config file"
try {
    $config = Get-Content -Path $ConfigFile | ConvertFrom-Json
}
catch {
    Write-Error "Failed to load config file"
    Exit-PSSession 1
}

Write-Verbose "Deploying resources"
try {
    Write-Verbose "Deleting network resource group"
    Remove-AzResourceGroup -Name $config.network.resourceGroup.name

    Write-Verbose "Deleting devbox resource group"
    Remove-AzResourceGroup -Name $config.devbox.resourceGroup.name
}
catch {
    Write-Error "Failed to delete resources"
    Exit-PSSession 1
}