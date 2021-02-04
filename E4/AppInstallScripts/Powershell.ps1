$VerbosePreference = 'Continue'
$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)) {
    New-Item  -ItemType Directory $BuildDir
    Write-Output 'Tried to make directory'
}
$allVersions = Get-MicrosoftPowerShell -Verbose
$mostRecent = $allVersions | Sort-Object -Descending -Property 'Version' | Select-Object -First 1 | Select-Object -ExpandProperty 'Version'
Write-Output "MostRecent: $mostRecent"
$allOnVersion = $allVersions | Where-Object { $_.version -eq $mostRecent }
Write-Output "allOnVersion: $allOnVersion"
$myVersion = $allOnVersion | Where-Object { $_.Architecture -eq 'x64'}
Write-Output "myVersion: $myVersion"
$fileName = split-path $myVersion.uri -Leaf
Write-Output "fileName: $fileName"
$outFile = join-path 'c:\CustomizerArtifacts' $fileName
Write-Output "outFile: $outFile"
if (-not(Test-Path $outFile)) {
    Invoke-WebRequest $myVersion.uri -OutFile $outFile -Verbose
    Write-Output "Invoke-WebRequest ran: $($myVersion.uri)"
}
Start-Process -FilePath msiexec.exe -Argument "/i $outFile /qn /norestart" -Wait -Verbose
Remove-Item $outFile -Verbose
Write-Output 'PowerShell Installed'
