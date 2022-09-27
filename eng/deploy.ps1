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
    Write-Error "Failed to switch subscription"
    Exit-PSSession 1
}

Write-Verbose "Deploying resources"
try {
    New-AzSubscriptionDeployment `
        -Name "Microsoft.Deployment" `
        -Location "uksouth" `
        -TemplateFile "./main.bicep" `
        -TemplateParameterFile "$ConfigFile"
}
catch {
    Write-Error "Failed to deploy resources"
    Exit-PSSession 1
}

# Write-Verbose "Creating assignment"
# try {
#     New-AzRoleAssignment `
#         -RoleDefinitionName "DevCenter Dev Box User" `
#         -ObjectId "" `
#         -Scope "/subscriptions/$SubscriptionId/resourceGroups/DevBox/{}/projects/default"
# }
# catch {
#     Write-Error "Failed to create role assignment"
#     Exit-PSSession 1
# }