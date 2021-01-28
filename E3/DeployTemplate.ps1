# Get your current subscription ID.
#$subscriptionID = (Get-AzContext).Subscription.Id

# Location
$location = "westeurope"

# Destination image resource group
$imageResourceGroup = 'YTAzureImageBuilderRG'

# Managed Identity Name
#$identityName = 'YTAIBIdentity_935323'

# Image gallery name
$sigGalleryName = "YTImageGalleryAIB"

. E1\Get-AzureImageInfo.ps1
$info = Get-AzureImageInfo -Location $location

# Image definition name
$imageDefName = $info.sku

# Image template name
$imageTemplateName = $info.sku

# Get identity details
#$identityNameResource = Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName

if ((Get-AzGalleryImageDefinition -ResourceGroupName $imageResourceGroup -GalleryName $sigGalleryName).Identifier.Sku -notcontains $info.Sku) {

    $paramNewAzGalleryImageDefinition = @{
        GalleryName       = $sigGalleryName
        ResourceGroupName = $imageResourceGroup
        Location          = $location
        Name              = $imageDefName
        OsState           = 'generalized'
        OsType            = 'Windows'
        Publisher         = $info.Publisher
        Offer             = $info.Offer
        Sku               = $info.Sku
    }
    New-AzGalleryImageDefinition @paramNewAzGalleryImageDefinition
}

$templateFilePath = ".\E3\TemplateFromPortalSKUBased\template.json"

if ((Get-AzImageBuilderTemplate).Name -contains $imageTemplateName) {
    Remove-AzImageBuilderTemplate -ImageTemplateName  $imageTemplateName -ResourceGroupName $imageResourceGroup
}

$paramNewAzResourceGroupDeployment = @{
    ResourceGroupName = $imageResourceGroup
    TemplateFile      = $templateFilePath
}
New-AzResourceGroupDeployment @paramNewAzResourceGroupDeployment

$paramInvokeAzResourceAction = @{
    ResourceName      = $imageTemplateName
    ResourceGroupName = $imageResourceGroup
    ResourceType      = 'Microsoft.VirtualMachineImages/imageTemplates'
    Action            = 'Run'
    Confirm           = $false
}
Invoke-AzResourceAction @paramInvokeAzResourceAction

# Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName -NoWait -PassThru