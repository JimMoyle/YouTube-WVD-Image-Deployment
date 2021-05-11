Write-Output 'GitForWindows Start'
#Make sure target directory is present
$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)) {
    New-Item  -ItemType Directory $BuildDir
}
#Use Evergreen to get all versions of Git For Windows.
$allVersions = Find-EvergreenApp -Name GitForWindows | Get-EvergreenApp

#Get Most recent version
$mostRecent = $allVersions | Sort-Object -Descending -Property 'Version' | Select-Object -First 1 | Select-Object -ExpandProperty 'Version'

#Get all packages on most recent version
$allOnVersion = $allVersions | Where-Object { $_.version -eq $mostRecent }

#Get package on our dedired architecture
$myVersion = $allOnVersion | Where-Object { $_.uri -like "*64-bit.exe"}

#Grab Filename
$fileName = split-path $myVersion.uri -Leaf

#Filename target
$outFile = join-path 'c:\CustomizerArtifacts' $fileName

#Download it if we don't already have it
if (-not(Test-Path $outFile)) {
    Invoke-WebRequest $myVersion.uri -OutFile $outFile
}

#Install it
Start-Process -FilePath $outFile -Argument "/VERYSILENT /NORESTART" -Wait

#Clean Up
Remove-Item $outFile
Write-Output 'GitForWindows Installed'