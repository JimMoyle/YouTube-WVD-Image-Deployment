$roleName = 'YT Azure Image Builder Service Image Creation Role'
$vnetName = 'West_Europe_AIB'

$rgName = (Get-AzVirtualNetwork -Name $vnetName).ResourceGroupName
$rgId = (Get-AzResourceGroup -Name $rgName).ResourceId


$role = Get-AzRoleDefinition $roleName

if ($role.AssignableScopes -notcontains $rgId) {
    $role.AssignableScopes.Add($rgId)
}

$nwPermission = 'Microsoft.Network/virtualNetworks/read' , 'Microsoft.Network/virtualNetworks/subnets/join/action'

foreach ($perm in $nwPermission) {
    if ($role.Actions -notcontains $perm) {
        $role.Actions.Add($perm)
    }
}

Set-AzRoleDefinition -Role $role

$identityNamePrincipalId = (Get-AzUserAssignedIdentity -ResourceGroupName 'YTAzureImageBuilderRG' -Name $identityName).PrincipalId
$subscriptionID = (Get-AzContext).Subscription.Id

$RoleAssignParams = @{
    ObjectId           = $identityNamePrincipalId
    RoleDefinitionName = $roleName
    Scope              = "/subscriptions/$subscriptionID/resourceGroups/$rgName"
}
New-AzRoleAssignment @RoleAssignParams