$paramNewAzResourceGroupDeployment = @{
    ResourceGroupName = 'Episode5'
    TemplateFile      = 'E5\TemplateForSystemTopic\template.json'
}
New-AzResourceGroupDeployment @paramNewAzResourceGroupDeployment