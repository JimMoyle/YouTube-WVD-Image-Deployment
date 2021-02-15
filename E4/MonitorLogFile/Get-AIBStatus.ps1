[CmdletBinding()]

Param (
    [Parameter(
        Position = 0,
        ValuefromPipelineByPropertyName = $true,
        ValuefromPipeline = $true
    )]
    [System.String]$ResourceGruopName = 'YTAzureImageBuilderRG',
    [Parameter(
        Position = 0,
        ValuefromPipelineByPropertyName = $true,
        ValuefromPipeline = $true
    )]
    [System.String]$ImageTemplateName = 'MicrosoftWindowsDesktop.office-365.20h2-evd-o365pp'
)

BEGIN {

    Set-StrictMode -Version Latest
} # Begin
PROCESS {
    while ($true) {
        Get-AzImageBuilderTemplate -ImageTemplateName  $imageTemplateName -ResourceGroupName $imageResourceGroup |
        Select-Object LastRunStatusRunState, LastRunStatusRunSubState, ProvisioningState, ProvisioningErrorMessage, LastRunStatusMessage
        Start-Sleep 5
        Clear-Host
    }
} #Process
END {} #End
