# VNET properties (update to match your existing VNET, or leave as-is for demo)
# VNET name
$vnetName = "myexistingvnet01"
# subnet name
$subnetName = "subnet01"
# VNET resource group name
$vnetRgName = "existingVnetRG"
# Existing Subnet NSG Name or the demo will create it
$nsgName = "aibdemoNsg"
# NOTE! The VNET must always be in the same region as the AIB service region.

$paramAddAzNetworkSecurityRuleConfig = @{
    Name = 'AzureImageBuilderAccess'
    Description = "Allow Image Builder Private Link Access to Proxy VM"
    Access = 'Allow'
    Protocol = 'Tcp'
    Direction = 'Inbound'
    Priority = 400
    SourceAddressPrefix =' AzureLoadBalancer'
    SourcePortRange = '*'
    DestinationAddressPrefix = 'VirtualNetwork'
    DestinationPortRange = '60000-60001'
}

Get-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $vnetRgName  |
    Add-AzNetworkSecurityRuleConfig @paramAddAzNetworkSecurityRuleConfig |
    Set-AzNetworkSecurityGroup

$virtualNetwork = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $vnetRgName

($virtualNetwork | Select-Object -ExpandProperty subnets | Where-Object { $_.Name -eq $subnetName } ).privateLinkServiceNetworkPolicies = "Disabled"

$virtualNetwork | Set-AzVirtualNetwork