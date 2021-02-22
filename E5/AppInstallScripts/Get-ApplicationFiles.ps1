$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)) {
    New-Item  -ItemType Directory $BuildDir
}

$path = 'C:\CustomizerArtifacts\Az.zip'
Expand-Archive -Path $path -DestinationPath (Join-Path $Env:USERPROFILE Documents\WindowsPowerShell\Modules)
Import-Module Az

$FileList = 'Az.zip', 'Get-ApplicationFiles.ps1'

Connect-AzAccount -Identity
$context = New-AzStorageContext -StorageAccountName episodefive -UseConnectedAccount
Get-AzStorageBlob -Context $context -Container applicationblob |
    Where-Object {$FileList -notcontains $_.name} |
    Get-AzStorageBlobContent -Destination $BuildDir