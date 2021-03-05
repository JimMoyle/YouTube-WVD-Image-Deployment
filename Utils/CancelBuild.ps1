$imageResourceGroup = 'YTAzureImageBuilderRG'
$imageResourceGroup = 'Episode5'
$location = 'westeurope'
. 'Utils\Get-AzureImageInfo.ps1'
$info = Get-AzureImageInfo -Location $location

# Image definition name
$imageTemplateName = $info.Publisher + '.' + $info.Offer + '.' + $info.sku

$paramInvokeAzResourceAction = @{
    ResourceName      = $imageTemplateName
    ResourceGroupName = $imageResourceGroup
    ResourceType      = 'Microsoft.VirtualMachineImages/imageTemplates'
    ApiVersion        = "2020-02-14"
    Action            = 'Cancel'
    Force             = $true
}
Invoke-AzResourceAction @paramInvokeAzResourceAction