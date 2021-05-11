Write-Output 'Teams Start'
$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)) {
    New-Item  -ItemType Directory $BuildDir
}
$allVersions = Find-EvergreenApp -Name MicrosoftTeams | Get-EvergreenApp
$mostRecent = $allVersions | Sort-Object -Descending -Property 'Version' | Select-Object -First 1 | Select-Object -ExpandProperty 'Version'
$allOnVersion = $allVersions | Where-Object { $_.version -eq $mostRecent }
$myVersion = $allOnVersion | Where-Object { $_.Architecture -eq 'x64'}
$fileName = split-path $myVersion.uri -Leaf
$outFile = join-path 'c:\CustomizerArtifacts' $fileName
if (-not(Test-Path $outFile)) {
    Invoke-WebRequest $myVersion.uri -OutFile $outFile
}
$teamsRegKey = 'HKLM:\SOFTWARE\Microsoft\Teams'
New-item $teamsRegKey | Out-Null
New-ItemProperty -Path $teamsRegKey -Name 'IsWVDEnvironment' -Value 1 -PropertyType DWORD | Out-Null
Start-Process -FilePath msiexec.exe -Argument "/i $outFile /quiet /norestart ALLUSER=1 ALLUSERS=1" -Wait
Remove-Item $outFile
Write-Output 'Teams Installed'