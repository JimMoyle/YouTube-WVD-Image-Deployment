#Create a gallery definition.
$imageResourceGroup = 'YTAzureImageBuilderRG'
$location = 'westeurope'
$imageDefName = 'YTImageForSIG'
$myGalleryName = 'YTImageGalleryAIB'

$info = Get-AzureImageInfo -Location $location

$ParamNewAzGalleryImageDefinition = @{
    GalleryName       = $myGalleryName
    ResourceGroupName = $imageResourceGroup
    Location          = $location
    Name              = $imageDefName
    OsState           = 'generalized'
    OsType            = 'Windows'
    Publisher         = $info.Publisher
    Offer             = $info.Offer
    Sku               = $info.Sku
}

$imageDef = New-AzGalleryImageDefinition @ParamNewAzGalleryImageDefinition
$imageDef.Id | Set-Content .\E2\TempFiles\imagedefid.txt