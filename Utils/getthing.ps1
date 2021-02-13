[CmdletBinding()]

Param (
    [Parameter(
        Position = 0,
        ValuefromPipelineByPropertyName = $true,
        ValuefromPipeline = $true
    )]
    [System.String]$Path = 'C:\Windows\temp\*.ps1'
)

BEGIN {
    Set-StrictMode -Version Latest
} # Begin
PROCESS {
    $regex = '.*PACKER OUT     azure-arm: \$password = \"(\w*)\"'
    $text = Get-Content $Path
    ($text | Select-String -Pattern $regex).Matches.Value -match $regex | Out-Null
    Write-Output $Matches[1]
} #Process
END {} #End