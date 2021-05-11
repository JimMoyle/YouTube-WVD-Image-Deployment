$rgName = 'Episode5'
$location = 'ukSouth'
$autoAcctName = 'Episode5Account'
# $script = 'E5\AutomationRunbookScripts\IHaveRun.ps1'
$script = 'E5\AutomationRunbookScripts\SummaryIncomingData.ps1'
$systemTopicName = 'SubscriptionTopic'
$identityName = 'YTAIBIdentity145675'

$path = Get-ChildItem $script
$Name = $path.BaseName
$webHookName = 'WebHook' + $Name
$runbookName = 'RunBook' + $Name
$eventSubscriptionName = 'EventSubs' + $Name

$identityNameResource = Get-AzUserAssignedIdentity -ResourceGroupName $rgName -Name $identityName

if ( -not ( Get-AzAutomationAccount -AutomationAccountName $autoAcctName -ResourceGroupName $rgName -ErrorAction SilentlyContinue ) ) {
    New-AzAutomationAccount -ResourceGroupName $rgName -Location $location -Name $autoAcctName

    #You now need to manually add the RunAs acct to the Automation acct.
    do {
        $q = "Has the manual addition of the runas acct on the automation account $autoAcctName finished creating? (y/n)"
        $a = Read-Host $q
        switch ($a) {
            'y' { break }
            'n' { Write-Output 'Go do it now' }
            Default { Clear-Host ; Read-Host $q }
        }
    } until ($a -eq 'y')

    #Az.Accounts needs to be first
    $modules = 'Az.Accounts', 'Az.Compute', 'Az.Resources'
    foreach ($moduleName in $modules) {

        $galleryData = Find-Module $moduleName
        $moduleVersion = $galleryData.Version

        $paramNewAzAutomationModule = @{
            AutomationAccountName = $autoAcctName
            ResourceGroupName     = $rgName
            Name                  = $moduleName
            ContentLinkUri        = "https://www.powershellgallery.com/api/v2/package/$moduleName/$moduleVersion"
        }
        New-AzAutomationModule @paramNewAzAutomationModule
        while ( (Get-AzAutomationModule -ResourceGroupName $rgname -Name $moduleName -AutomationAccountName $autoAcctName).ProvisioningState -ne 'Succeeded'){
            Start-Sleep 1
        }
    }
}

<# Don't bother with this it's awful

$password = & E5\GenerateRandomPassword.ps1

$param = @{
    ResourceGroup               = $rgName
    AutomationAccountName       = $acct.AutomationAccountName
    SubscriptionId              = $acct.SubscriptionId
    ApplicationDisplayName      = 'Episode5'
    SelfSignedCertPlainPassword = $password
    CreateClassicRunAsAccount   = $false
}

# So this reconnects to the az account (Opens Web Page) and requires the Windows SDK - I am not a fan
& E5\Create-RunAsAccount.ps1 @param

#>

#Clean up sample tutorial runbooks
Get-AzAutomationRunbook -ResourceGroupName $rgName -AutomationAccountName $autoAcctName | Where-Object { $_.Name -like "*tutorial*" } | Remove-AzAutomationRunbook -Force

$params = @{
    ResourceGroupName     = $rgName
    AutomationAccountName = $autoAcctName
    RunbookName           = $RunbookName
}

Remove-AzAutomationRunbook -Force @params -ErrorAction SilentlyContinue
Import-AzAutomationRunbook -Path $script -Type PowerShell @params
Publish-AzAutomationRunbook @params

Remove-AzAutomationWebhook -ResourceGroupName $rgName -AutomationAccountName $autoAcctName -Name $webHookName -ErrorAction SilentlyContinue
$webHook = New-AzAutomationWebhook -Name $webHookName -IsEnabled $true -ExpiryTime (Get-Date).AddYears(1) -Force @params
Get-AzResourceProvider -ProviderNamespace Microsoft.EventGrid |
Where-Object RegistrationState -NE Registered |
Register-AzResourceProvider

#EventGrid Powershell doesn't support system topics, or subscribing to system topics so let's use an ARM Template

$prinId = $identityNameResource.PrincipalId.Replace('-', '')
$last25 = $prinId.Substring($prinId.length - 25, 25)

$paramNewAzResourceGroupDeployment = @{
    ResourceGroupName     = $rgName
    TemplateFile          = 'E5\TemplateForEventGrid\SubscriptionTemplate.json'

    EventSubscriptionName = $eventSubscriptionName
    TopicName             = $systemTopicName
    WebHookUri            = $webHook.WebhookURI
    ManagedId             = $last25
}

New-AzResourceGroupDeployment @paramNewAzResourceGroupDeployment