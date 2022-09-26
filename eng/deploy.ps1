<#
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    $SubscriptionId,

    [Parameter(Mandatory = $false)]
    $ConfigFile = "../src/configs/main.json",

    [Parameter(Mandatory = $false)]
    $WhatIf = $false
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

Write-Verbose "Deploying resources"
try {
    New-AzSubscriptionDeployment `
        -Name "Microsoft.Deployment" `
        -Location "uksouth" `
        -TemplateFile "./main.bicep" `
        -TemplateParameterFile "$ConfigFile" `
        -WhatIf:$WhatIf
}
catch {
    Write-Error "Failed to deploy resources"
    Exit-PSSession 1
}
