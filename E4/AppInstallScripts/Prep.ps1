New-Item  -ItemType Directory 'C:\CustomizerArtifacts' -Verbose
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Verbose
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -Verbose
Install-Module EverGreen -Verbose
Write-Output 'Prep Done'