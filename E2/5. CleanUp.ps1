$imageResourceGroup = 'YTAzureImageBuilderRG'
$imageTemplateName = 'YTWin10Image'

#CleanUp
Remove-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup