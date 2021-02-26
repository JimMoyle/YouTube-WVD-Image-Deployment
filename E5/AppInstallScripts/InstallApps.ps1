$BuildDir = 'c:\CustomizerArtifacts'

$fslogixFile = Join-Path  $BuildDir 'FSLogix_Apps_2.9.7654.46150.zip'
$extPath = Join-Path  $BuildDir 'FSLogix'
Expand-Archive $fslogixFile $extPath
Start-Process -FilePath (Join-Path $extPath "\x64\Release\FSLogixAppsSetup.exe") -Argument '-install -quiet -norestart' -Wait
Remove-Item $extPath -Recurse
Write-Output 'FSLogix Installed'

$gfwFile = Join-Path  $BuildDir 'Git-2.30.1-64-bit.exe'
Start-Process -FilePath $gfwFile -Argument "/VERYSILENT /NORESTART" -Wait
Write-Output 'GitForWindows Installed'

$PowerShellFile = Join-Path  $BuildDir 'PowerShell-7.1.2-win-x64.msi'
Start-Process -FilePath msiexec.exe -Argument "/i $PowerShellFile /qn /norestart" -Wait
Write-Output 'PowerShell Core Installed'

$teamsFile = Join-Path  $BuildDir 'Teams_windows_x64.msi'
$teamsRegKey = 'HKLM:\SOFTWARE\Microsoft\Teams'
New-Item $teamsRegKey | Out-Null
New-ItemProperty -Path $teamsRegKey -Name 'IsWVDEnvironment' -Value 1 -PropertyType DWORD | Out-Null
Start-Process -FilePath msiexec.exe -Argument "/i $teamsFile /quiet /norestart ALLUSER=1 ALLUSERS=1" -Wait
Write-Output 'Teams Installed'