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

Write-Information "=> Starting deployment process..."

# TODO: Add role assignment

Write-Information "==> Switching subscriptions..."
try {
    $null = Set-AzContext -SubscriptionId $SubscriptionId
}
catch {
    Write-Warning "Failed to switch subscription `nMESSAGE: $($_.Exception.Message)"
    exit 1
}

Write-Information "==> Deploying resources..."
try {
    New-AzSubscriptionDeployment `
        -Name "Microsoft.Deployment.PowerShell" `
        -Location "uksouth" `
        -TemplateFile ((Split-Path $PSScriptRoot) + "/src/main.bicep") `
        -TemplateParameterFile "$ConfigFile"
}
catch {
    Write-Warning "Failed to deploy resources `nMESSAGE: $($_.Exception.Message)"
    exit 1
}
