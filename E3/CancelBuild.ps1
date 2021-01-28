$imageResourceGroup = 'YTAzureImageBuilderRG'
. E1\Get-AzureImageInfo.ps1
$info = Get-AzureImageInfo -Location $location

# Image definition name
$imageTemplateName = $info.sku

Invoke-AzResourceAction -ResourceName $imageTemplateName -ResourceGroupName $imageResourceGroup -ResourceType Microsoft.VirtualMachineImages/imageTemplates -ApiVersion "2020-02-14" -Action Cancel -Force