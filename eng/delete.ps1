#Requires -Version 7.0
#Requires -Modules Az.Accounts, Az.Resources

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    $SubscriptionId,

    [Parameter(Mandatory = $false)]
    $ParameterFile = ((Split-Path $PSScriptRoot) + "/src/parameters/main.json"),

    $InformationPreference = 'Continue',
    $ErrorActionPreference = 'Stop'
)

Write-Information "=> Starting deletion process..."

try {
    Write-Information "==> Switching subscription..."
    $null = Set-AzContext -SubscriptionId $SubscriptionId
}
catch {
    Write-Warning "Failed to switch subscription `nMESSAGE: $($_.Exception.Message)"
    exit 1
}

try {
    Write-Information "==> Parsing parameter file..."
    $networkSettings = (Get-Content -Path $ParameterFile | ConvertFrom-Json).parameters.networkSettings.value
    $computeSettings = (Get-Content -Path $ParameterFile | ConvertFrom-Json).parameters.computeSettings.value
    $identitySettings = (Get-Content -Path $ParameterFile | ConvertFrom-Json).parameters.identitySettings.value
    $devcenterSettings = (Get-Content -Path $ParameterFile | ConvertFrom-Json).parameters.devcenterSettings.value
}
catch {
    Write-Warning "Failed to parse parameter data `nMESSAGE: $($_.Exception.Message)"
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
        Write-Information "==> Deleting devcenter resources..."
        Remove-AzResourceGroup -Name $devcenterSettings.resourceGroup.name -Force

        Write-Information "==> Deleting compute resources..."
        Remove-AzResourceGroup -Name $computeSettings.resourceGroup.name -Force

        Write-Information "==> Deleting identity resources..."
        Remove-AzResourceGroup -Name $identitySettings.resourceGroup.name -Force

        Write-Information "==> Deleting network resources..."
        Remove-AzResourceGroup -Name $networkSettings.resourceGroup.name -Force
    }
}
catch {
    Write-Warning "Failed to delete resources `nMESSAGE: $($_.Exception.Message)"
    exit 1
}
