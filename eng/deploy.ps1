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

Write-Information "=> Starting deployment process..."

# TODO: Add role assignment

try {
    Write-Information "==> Switching subscription..."
    $null = Set-AzContext -SubscriptionId $SubscriptionId
}
catch {
    Write-Warning "Failed to switch subscription `nMESSAGE: $($_.Exception.Message)"
    exit 1
}

try {
    if ($env:CI -eq "true") {
        Write-Information "==> Validating resources..."
        New-AzSubscriptionDeployment `
            -Name "Microsoft.Deployment.PowerShell" `
            -Location "uksouth" `
            -TemplateFile ((Split-Path $PSScriptRoot) + "/src/main.bicep") `
            -TemplateParameterFile "$ParameterFile" `
            -WhatIf
    }
    else {
        Write-Information "==> Deploying resources..."
        New-AzSubscriptionDeployment `
            -Name "Microsoft.Deployment.PowerShell" `
            -Location "uksouth" `
            -TemplateFile ((Split-Path $PSScriptRoot) + "/src/main.bicep") `
            -TemplateParameterFile "$ParameterFile"
    }
}
catch {
    Write-Warning "Failed to deploy resources `nMESSAGE: $($_.Exception.Message)"
    exit 1
}
