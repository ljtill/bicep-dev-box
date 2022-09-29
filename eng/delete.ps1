#Requires -Version 7.0
#Requires -Modules Az.Accounts, Az.Resources

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    $SubscriptionId,

    [Parameter(Mandatory = $false)]
    $ConfigFile = ((Split-Path $PSScriptRoot) + "/src/configs/main.json"),

    $InformationPreference = 'Continue',
    $ErrorActionPreference = 'Stop'
)

Write-Information "=> Starting deletion process..."

try {
    Write-Information "==> Switching subscriptions..."
    $null = Set-AzContext -SubscriptionId $SubscriptionId
}
catch {
    Write-Warning "Failed to switch subscriptions `nMESSAGE: $($_.Exception.Message)"
    exit 1
}

try {
    Write-Information "==> Parsing config file..."
    $config = (Get-Content -Path $ConfigFile | ConvertFrom-Json).parameters.config.value
}
catch {
    Write-Warning "Failed to parse config data `nMESSAGE: $($_.Exception.Message)"
    exit 1
}

try {
    trap {
        if ($_.Exception.Message -notlike "* - Provided resource group does not exist.") {
            throw $_.Exception
        }
        continue
    }

    if ($env:CI -eq "true") {
        Write-Information "==> Skipping resource deletion..."
    }
    else {
        Write-Information "==> Deleting devbox resources..."
        Remove-AzResourceGroup -Name $config.devbox.resourceGroup.name

        Write-Information "==> Deleting network resources..."
        Remove-AzResourceGroup -Name $config.network.resourceGroup.name
    }
}
catch {
    Write-Warning "Failed to delete resources `nMESSAGE: $($_.Exception.Message)"
    exit 1
}
