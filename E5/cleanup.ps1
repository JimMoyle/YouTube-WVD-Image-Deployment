$rgName = 'Episode5'
$location = 'UKSouth'
$autoAcctName = 'Episode5Account'

Remove-AzAutomationAccount -ResourceGroupName $rgName -Name $autoAcctName -Force

Unregister-AzResourceProvider -ProviderNamespace Microsoft.EventGrid

