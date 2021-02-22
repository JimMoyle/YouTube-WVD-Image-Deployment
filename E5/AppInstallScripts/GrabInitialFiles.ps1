$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)) {
    New-Item  -ItemType Directory $BuildDir
}

$audience = 'https://storage.azure.com'
$token = $false
while ($token) {
    try {
        $token = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$audience" -Headers @{ 'Metadata' = 'true' }
        $token = $true
    }
    catch {
        $token = $false
        Start-Sleep 1
        Write-Output 'No Token'
    }
}

$storageAccountName = 'episodefive'
$container = 'applicationblob'
$FileList = 'Az.zip', 'Get-ApplicationFiles.ps1'
foreach ($file in $fileList) {
    $blob = "https://$storageAccountName.blob.core.windows.net/$container/$file"
    $auth = "$($token.token_type) $($token.access_token)"
    Invoke-RestMethod -Method GET -Uri $blob -Headers @{
        'Authorization' = $auth
        'x-ms-version'  = '2019-02-02'
    } -OutFile (Join-Path $BuildDir $file)
}