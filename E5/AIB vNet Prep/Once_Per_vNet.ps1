# VNET name
# NOTE! The VNET must always be in the same region as the AIB service region.
$vnet = "West_Europe_AIB"
# subnet name
$subnet = "default"

# Existing Subnet NSG Name or the demo will create it
$nsg = "nsgEpisode5"
$nsgResourceGroup = "Episode5"

# VNET resource group name
$vnetResourceGroup = 'WVD_Permanent_Resources'

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