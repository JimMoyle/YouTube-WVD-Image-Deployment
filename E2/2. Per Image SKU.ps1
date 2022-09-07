#Create a gallery definition.
$imageResourceGroup = 'YTAzureImageBuilderRG'
$location = 'westeurope'
$imageDefName = 'YTImageForSIG'
$myGalleryName = 'YTImageGalleryAIB'
$imageTemplateName = 'YTWin10Image'
$runOutputName = 'YTDistResults'
$identityNameResourceId = Get-Content .\E2\TempFiles\identityNameId.txt

. E1\Get-AzureImageInfo.ps1
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

#########################################
#
# Create an image Builder Template
#
#########################################

#Create an Azure image builder source object

$SrcObjParams = @{
    SourceTypePlatformImage = $true
    Publisher               = $info.Publisher
    Offer                   = $info.Offer
    Sku                     = $info.Sku
    Version                 = 'latest'
}
$srcPlatform = New-AzImageBuilderTemplateSourceObject -PlatformImageSource @SrcObjParams

#Create an Azure image builder customization object.

$ImgCustomParams = @{
    Name       = 'settingUpMgmtAgtPath'
    RunElevated          = $false
    Inline               = @("mkdir c:\\buildActions", "echo Azure-Image-Builder-Was-Here  > c:\\buildActions\\buildActionsOutput.txt")
}
$Customizer = New-AzImageBuilderTemplateCustomizerObject -PowerShellCustomizer @ImgCustomParams

#Create an Azure image builder distributor object.

$disObjParams = @{
    SharedImageDistributor = $true
    ArtifactTag            = @{tag = 'Jim-Share' }
    GalleryImageId         = $imageDef.Id
    ReplicationRegion      = $location
    RunOutputName          = $runOutputName
    ExcludeFromLatest      = $false
}
$disSharedImg = New-AzImageBuilderTemplateDistributorObject @disObjParams

#Create an Azure image builder template.

$ImgTemplateParams = @{
    ImageTemplateName      = $imageTemplateName
    ResourceGroupName      = $imageResourceGroup
    Source                 = $srcPlatform
    Distribute             = $disSharedImg
    Customize              = $Customizer
    Location               = $location
    UserAssignedIdentityId = $identityNameResourceId
}
New-AzImageBuilderTemplate @ImgTemplateParams
