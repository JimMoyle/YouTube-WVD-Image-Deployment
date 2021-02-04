$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)) {
    New-Item  -ItemType Directory $BuildDir
}
$allVersions = Get-MicrosoftTeams
$mostRecent = $allVersions | Sort-Object -Descending -Property 'Version' | Select-Object -First 1 | Select-Object -ExpandProperty 'Version'
$allOnVersion = $allVersions | Where-Object { $_.version -eq $mostRecent }
$myVersion = $allOnVersion | Where-Object {$_.Architecture -eq 'x64' -and $_.Type -eq 'exe' -and $_.uri -notlike "*portable*"}
$fileName = split-path $myVersion.uri -Leaf
$outFile = join-path 'c:\CustomizerArtifacts' $fileName
if (-not(Test-Path $outFile)) {
    Invoke-WebRequest $myVersion.uri -OutFile $outFile
}
Start-Process -FilePath $outFile -Argument "/VERYSILENT /NORESTART" -Wait
Remove-Item $outFile
Write-Host 'GitForWindows Installed'