Write-Output 'PSGallery Modules Install Started'
New-Item  -ItemType Directory 'C:\CustomizerArtifacts'  | Out-Null
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted  | Out-Null
Install-Module EverGreen
Install-Module Az
Write-Output 'PSGallery Modules Install Finished'