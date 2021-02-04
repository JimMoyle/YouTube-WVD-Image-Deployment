New-Item c:\CustomizerArtifacts -ItemType Directory
$g = get-gitforwindows
$gfw = $g | ? {$_.Architecture -eq 'x64' -and $_.Type -eq 'exe' -and $_.uri -notlike "*portable*"}
iwr $gfw.uri -OutFile c:\CustomizerArtifacts\gfw.exe
c:\CustomizerArtifacts\gfw.exe /VERYSILENT /NORESTART
$stop