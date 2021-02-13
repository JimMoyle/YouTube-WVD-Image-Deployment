Write-Output 'FSLogix Start'
$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)){
    New-Item -ItemType Directory $BuildDir
}
$myVersion = Get-MicrosoftFSLogixApps
$fileName = split-path $myVersion.uri -Leaf -Verbose
$outFile = join-path 'c:\CustomizerArtifacts' $fileName
Invoke-WebRequest $myVersion.uri -OutFile $outFile
$extPath = Join-Path  $BuildDir 'FSLogix'
Expand-Archive $outFile $extPath
Start-Process -FilePath (Join-Path $extPath "\x64\Release\FSLogixAppsSetup.exe") -Argument '-install -quiet -norestart' -Wait
Remove-Item $outFile
Remove-Item $extPath -Recurse
Write-Output 'FSLogix Installed'