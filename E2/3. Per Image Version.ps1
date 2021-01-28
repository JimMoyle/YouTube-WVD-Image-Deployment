$imageResourceGroup = 'YTAzureImageBuilderRG'
$imageTemplateName = 'YTWin10Image'

#Start build asynchronously
Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName -NoWait -PassThru