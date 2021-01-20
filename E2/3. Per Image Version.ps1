$imageResourceGroup = 'YTAzureImageBuilderRG'
$imageTemplateName = 'YTWin10Image'
$location = 'westeurope'
$runOutputName = 'YTDistResults'
$imageDefId = Get-Content .\E2\TempFiles\imagedefid.txt
$identityNameResourceId = Get-Content .\E2\TempFiles\identityNameId.txt

. E1\Get-AzureImageInfo.ps1
$info = Get-AzureImageInfo -Location $location

#########################################
#
# Create an image
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
$srcPlatform = New-AzImageBuilderSourceObject @SrcObjParams

#Create an Azure image builder customization object.

$ImgCustomParams = @{
    PowerShellCustomizer = $true
    CustomizerName       = 'settingUpMgmtAgtPath'
    RunElevated          = $false
    Inline               = @("mkdir c:\\buildActions", "echo Azure-Image-Builder-Was-Here  > c:\\buildActions\\buildActionsOutput.txt")
}
$Customizer = New-AzImageBuilderCustomizerObject @ImgCustomParams

#Create an Azure image builder distributor object.

$disObjParams = @{
    SharedImageDistributor = $true
    ArtifactTag            = @{tag = 'dis-share' }
    GalleryImageId         = $imageDefId
    ReplicationRegion      = $location
    RunOutputName          = $runOutputName
    ExcludeFromLatest      = $false
}
$disSharedImg = New-AzImageBuilderDistributorObject @disObjParams

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

#Start build asynchronously
Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName -NoWait