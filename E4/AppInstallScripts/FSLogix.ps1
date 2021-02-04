$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)){
    New-Item  -ItemType Directory $BuildDir
}
$myVersion = Get-MicrosoftFSLogixApps
#$myVersion = $g | Where-Object {$_.Architecture -eq 'x64' -and $_.Channel -eq 'Stable' -and $_.platform -eq "win32-x64"}
$fileName = split-path $myVersion.uri -Leaf
$outFile = join-path 'c:\CustomizerArtifacts' $fileName
Invoke-WebRequest $myVersion.uri -OutFile $outFile
$extPath = Join-Path  $BuildDir 'FSLogix'
Expand-Archive $outFile $extPath
Start-Process -FilePath (Join-Path $extPath "\x64\Release\FSLogixAppsSetup.exe") -Argument '-install -quiet -norestart' -Wait
Remove-Item $outFile
Remove-Item $extPath -Recurse
Write-Host 'FSLogix Installed'