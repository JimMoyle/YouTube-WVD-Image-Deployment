Write-Output 'BISF Start'

$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)) {
    New-Item  -ItemType Directory $BuildDir
}
$allVersions = Get-BISF
$mostRecent = $allVersions | Sort-Object -Descending -Property 'Version' | Select-Object -First 1 | Select-Object -ExpandProperty 'Version'
$allOnVersion = $allVersions | Where-Object { $_.version -eq $mostRecent }
$myVersion = $allOnVersion
$fileName = Split-Path $myVersion.uri -Leaf
$outFile = Join-Path 'c:\CustomizerArtifacts' $fileName
if (-not(Test-Path $outFile)) {
    Invoke-WebRequest $myVersion.uri -OutFile $outFile
}
Start-Process -FilePath msiexec.exe -Argument "/i $outFile /qn" -Wait
Remove-Item $outFile
Write-Output 'BISF Installed'
$bisfPath = 'C:\Program Files (x86)\Base Image Script Framework (BIS-F)'
$jsonPath = "https://raw.githubusercontent.com/JimMoyle/YouTube-WVD-Image-Deployment/main/E4/BISF/BISFconfig_MicrosoftWindows10EnterpriseforVirtualDesktops_64-bit.json", "https://raw.githubusercontent.com/JimMoyle/YouTube-WVD-Image-Deployment/main/E4/BISF/BISFSharedConfig.json"
foreach ($file in $jsonPath) {
    $fileName = Split-Path $file -Leaf
    $outFile = Join-Path $bisfPath $fileName
    if (-not(Test-Path $outFile)) {
        Invoke-WebRequest $file -OutFile $outFile
    }
}
$startBISF = Join-Path $bisfPath "\Framework\PrepBISF_Start.ps1"
& $startBISF
Write-Output 'BISF Run Finished'