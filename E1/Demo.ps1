# All files will be available in my associated GitHub repository
# https://github.com/JimMoyle/YouTube-WVD-Image-Deployment

# Check we're connected to Azure
(Get-AzContext).Account.id

# There variables are needed so we know which image to base things from
$Location = 'uksouth'
$PublisherName = 'MicrosoftWindowsDesktop'
$Offer = 'office-365'
$SkuMatchString = '*evd*'

# Making sure we know the latest version of the image published by Microsoft
$sku = Get-AzVMImageSku -Location $Location -PublisherName $PublisherName -Offer $Offer | Where-Object { $_.Skus -like $SkuMatchString }
$sku
$sku | Get-AzVMImage | Sort-Object -Descending -Property Version | Select-Object -First 1

# I've put this into a function for you to use (works for any image, but defaults are for WVD)
. .\E1\Get-AzureImageInfo.ps1

Get-AzureImageInfo -Location 'uksouth'

# Validate JSON
& packer validate E1\Windows10ManagedImage.json

# Do the build

# All you really need is the JSON and this packer build line
& packer build E1\Windows10ManagedImage.json


# Need an image definition in the gallery for this to work
$ParamNewAzGalleryImageDefinition = @{
    GalleryName       = 'PackerSIG'
    ResourceGroupName = 'Packer'
    Location          = 'uksouth'
    Name              = 'MyImageForSIG'
    OsState           = 'generalized'
    OsType            = 'Windows'
    Publisher         = 'MicrosoftWindowsDesktop'
    Offer             = 'office-365'
    Sku               = '20h2-evd-o365pp'
}

New-AzGalleryImageDefinition @ParamNewAzGalleryImageDefinition

& packer validate E1\Windows10SharedImageGallery.json

# Do the build
& packer build E1\Windows10SharedImageGallery.json
