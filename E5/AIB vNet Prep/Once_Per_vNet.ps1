# VNET name
$vnet = "West_Europe_AIB"
# subnet name
$subnet = "default"
# VNET resource group name
$vnetResourceGroup = "WVD_Permanent_Resources"
# Existing Subnet NSG Name or the demo will create it

$nsg = "nsgEpisode5"
# NOTE! The VNET must always be in the same region as the AIB service region.

$nsgResourceGroup = "Episode5"

$paramAddAzNetworkSecurityRuleConfig = @{
    Name = 'AzureImageBuilderAccess'
    Description = "Allow Image Builder Private Link Access to Proxy VM"
    Access = 'Allow'
    Protocol = 'Tcp'
    Direction = 'Inbound'
    Priority = 400
    SourceAddressPrefix = 'AzureLoadBalancer'
    SourcePortRange = '*'
    DestinationAddressPrefix = 'VirtualNetwork'
    DestinationPortRange = '60000-60001'
}

Get-AzNetworkSecurityGroup -Name $nsg -ResourceGroupName $nsgResourceGroup  |
    Add-AzNetworkSecurityRuleConfig @paramAddAzNetworkSecurityRuleConfig |
    Set-AzNetworkSecurityGroup

$virtualNetwork = Get-AzVirtualNetwork -Name $vnet -ResourceGroupName $vnetResourceGroup

($virtualNetwork | Select-Object -ExpandProperty subnets | Where-Object { $_.Name -eq $subnet } ).privateLinkServiceNetworkPolicies = "Disabled"

$virtualNetwork | Set-AzVirtualNetwork