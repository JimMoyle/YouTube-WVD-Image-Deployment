$vmname = 'Personal-0'

$vm = Get-AzVM -Name $vmname
Update-AzVM -VM $vm -IdentityType SystemAssigned -ResourceGroupName $vm.ResourceGroupName


$vm = Get-AzVM -Name $vmname
$id = $vm.Identity.PrincipalId
Set-AzKeyVaultAccessPolicy -VaultName 'EpisodeFiveVault' -PermissionsToSecrets Get -ObjectId $id

$storageAcct = '/subscriptions/2f1abbf5-752d-446a-9846-2a349ee2776e/resourceGroups/Episode5/providers/Microsoft.Storage/storageAccounts/episodefive'
$fileService = '/subscriptions/2f1abbf5-752d-446a-9846-2a349ee2776e/resourceGroups/Episode5/providers/Microsoft.Storage/storageAccounts/episodefive/fileServices/default'
$blobService = '/subscriptions/2f1abbf5-752d-446a-9846-2a349ee2776e/resourceGroups/Episode5/providers/Microsoft.Storage/storageAccounts/episodefive/blobServices/default'

New-AzRoleAssignment -ObjectId $id -RoleDefinitionName "Reader" -Scope $storageAcct