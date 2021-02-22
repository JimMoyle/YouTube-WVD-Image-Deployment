# Path to template
$templateFilePath = ".\E5\Template\template.json"

# Location
$location = "westeurope"

# Destination image resource group
$imageResourceGroup = 'YTAzureImageBuilderRG'

# Managed Identity Name
$identityName = 'YTAIBIdentity'

# Image gallery name
$sigGalleryName = "YTImageGalleryAIB"

#image definition 'name'
$destPublisher = 'Developer'
$destOffer = 'en-GB'

#Image definition version
$version = '1.5.22'

#Staging VM size
$vmSize = 'Standard_D2_v2'

. Utils\Get-AzureImageInfo.ps1
$info = Get-AzureImageInfo -Location $location

$Sku = $info.sku
$srcPublisher = $info.Publisher
$srcOffer = $info.Offer

$destCombined = $destPublisher + '.' + $destOffer + '.' + $Sku
$srcCombined = $srcPublisher + '.' + $srcOffer + '.' + $Sku

# Image definition name
$imageDefName = $destCombined

# Image template name
$imageTemplateName = $srcCombined

# Get identity details
$identityNameResource = Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName

if ((Get-AzGalleryImageDefinition -ResourceGroupName $imageResourceGroup -GalleryName $sigGalleryName).Name -notcontains $imageDefName) {

    $paramNewAzGalleryImageDefinition = @{
        GalleryName       = $sigGalleryName
        ResourceGroupName = $imageResourceGroup
        Location          = $location
        Name              = $imageDefName
        OsState           = 'generalized'
        OsType            = 'Windows'
        Publisher         = $destPublisher
        Offer             = $destOffer
        Sku               = $Sku
        ErrorAction       = 'SilentlyContinue'
    }
    New-AzGalleryImageDefinition @paramNewAzGalleryImageDefinition
}

$imageVersions = Get-AzGalleryImageVersion -GalleryImageDefinitionName $imageDefName -ResourceGroupName $imageResourceGroup -GalleryName $sigGalleryName
$verList = foreach ($ver in $imageVersions.Name) {
    [version]$ver
}
$topVersion = $verList | Sort-Object -Descending | Select-Object -First 1

if ( [version]$Version -le $topVersion ) {
    Write-Error "Specified Version $Version not greater than current available $topVersion"
    break
}
#$gallery = Get-AzGallery -ResourceGroupName $imageResourceGroup -GalleryName $sigGalleryName

$imageDefinition = Get-AzGalleryImageDefinition -ResourceGroupName $imageResourceGroup -GalleryName $sigGalleryName -Name $imageDefName

if ((Get-AzImageBuilderTemplate).Name -contains $imageTemplateName) {
    Remove-AzImageBuilderTemplate -ImageTemplateName  $imageTemplateName -ResourceGroupName $imageResourceGroup
}

$paramNewAzResourceGroupDeployment = @{
    ResourceGroupName = $imageResourceGroup
    TemplateFile      = $templateFilePath

    Version           = $version
    vmSize            = $vmSize
    imageId           = $imageDefinition.Id
    identityId        = $identityNameResource.Id
    SrcPublisher      = $srcPublisher
    SrcOffer          = $srcOffer
    SrcSKU            = $Sku
}
New-AzResourceGroupDeployment @paramNewAzResourceGroupDeployment

$paramInvokeAzResourceAction = @{
    ResourceName      = $imageTemplateName
    ResourceGroupName = $imageResourceGroup
    ResourceType      = 'Microsoft.VirtualMachineImages/imageTemplates'
    Action            = 'Run'
    Force             = $true
}
Invoke-AzResourceAction @paramInvokeAzResourceAction