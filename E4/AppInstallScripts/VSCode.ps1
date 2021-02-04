$BuildDir = 'c:\CustomizerArtifacts'
if (-not(Test-Path $BuildDir)){
    New-Item  -ItemType Directory $BuildDir
}
$g = Get-MicrosoftVisualStudioCode
$gfw = $g | Where-Object {$_.Architecture -eq 'x64' -and $_.Channel -eq 'Insider' -and $_.platform -eq "win32-x64"}
$fileName = split-path $gfw.uri -Leaf
$outFile = join-path 'c:\CustomizerArtifacts' $fileName
Invoke-WebRequest $gfw.uri -OutFile $outFile
Start-Process -FilePath $outFile -Argument "/VERYSILENT /suppressmsgboxes /MERGETASKS=!runcode" -Wait
$stop