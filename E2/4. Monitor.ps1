$imageResourceGroup = 'YTAzureImageBuilderRG'
$imageTemplateName = 'YTWin10Image'

$state = Get-AzImageBuilderTemplate -ImageTemplateName  $imageTemplateName -ResourceGroupName $imageResourceGroup
$state | Select-Object LastRunStatusRunState, LastRunStatusRunSubState, ProvisioningState, ProvisioningErrorMessage
