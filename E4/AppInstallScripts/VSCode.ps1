Write-Output 'VSCode Start'
$BuildDir = 'C:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)){
    New-Item  -ItemType Directory $BuildDir
}
$allVersions = Find-EvergreenApp -Name MicrosoftVisualStudioCode | Get-EvergreenApp
$mostRecent = $allVersions |  Where-Object { $_.Channel -eq 'Stable' } | Sort-Object -Descending -Property 'Version' | Select-Object -First 1 | Select-Object -ExpandProperty 'Version'
$allOnVersion = $allVersions | Where-Object { $_.version -eq $mostRecent }
$myVersion = $allOnVersion | Where-Object { $_.Architecture -eq 'x64' -and $_.platform -eq "win32-x64" }
$fileName = Split-Path $myVersion.uri -Leaf
$outFile = Join-Path 'c:\CustomizerArtifacts' $fileName
if (-not(Test-Path $outFile)) {
    Invoke-WebRequest $myVersion.uri -OutFile $outFile
}
Start-Process -FilePath $outFile -Argument "/VERYSILENT /suppressmsgboxes /MERGETASKS=!runcode" -Wait
Remove-Item $outFile
Write-Output 'VSCode Installed'