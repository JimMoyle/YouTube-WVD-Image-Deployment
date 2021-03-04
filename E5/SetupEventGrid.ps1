$rgName = 'Episode5'
$location = 'UKSouth'
$autoAcctName = 'Episode5Account'
$script = 'E5\AutomationRunbookScripts\IHaveRun.ps1'
$systemTopicName = 'SubscriptionTopic'

$path = Get-ChildItem $script
$Name = $path.BaseName
$webHookName = 'WebHook' + $Name
$runbookName = 'RunBook' + $Name
$eventSubscriptionName = 'EventSubs' + $Name

if ( -not ( Get-AzAutomationAccount -AutomationAccountName $autoAcctName -ResourceGroupName $rgName -ErrorAction SilentlyContinue ) ) {
    New-AzAutomationAccount -ResourceGroupName $rgName -Location $location -Name $autoAcctName

    #You now need to manually add the RunAs acct to the Automation acct.

    do {
        $q = "Has the runas acct on the automation account $autoAcctName finished creating? (y/n)"
        $a = Read-Host $q
        switch ($a) {
            'y' { break }
            'n' { Write-Output 'Go do it now' }
            Default { Read-Host $q }
        }
    } until ($a -eq 'y')
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

$params = @{
    ResourceGroupName     = $rgName
    AutomationAccountName = $autoAcctName
    RunbookName           = $RunbookName
}

#Clean up sample tutorial runbooks
Get-AzAutomationRunbook -ResourceGroupName $rgName -AutomationAccountName $autoAcctName | Where-Object { $_.Name -like "*tutorial*" } | Remove-AzAutomationRunbook -Force

#Create new runbook from our script
$scriptPath = "E5\AutomationRunbookScripts\IHaveRun.ps1"
#$scriptPath = "E5\AutomationRunbookScripts\SummaryIncomingData.ps1"

Remove-AzAutomationRunbook -Force @params -ErrorAction SilentlyContinue
Import-AzAutomationRunbook -Path $scriptPath -Type PowerShell @params
Publish-AzAutomationRunbook @params

Remove-AzAutomationWebhook -ResourceGroupName $rgName -AutomationAccountName $autoAcctName -Name $webHookName -ErrorAction SilentlyContinue
$webHook = New-AzAutomationWebhook -Name $webHookName -IsEnabled $true -ExpiryTime (Get-Date).AddYears(1) -Force @params

Get-AzResourceProvider -ProviderNamespace Microsoft.EventGrid |
    Where-Object RegistrationState -NE Registered |
    Register-AzResourceProvider

#EventGrid Powershell doesn't support system topics, or subscribing to system topics

#At this point the Sytem Topic should have been created by you separately using the supplied ARM template
New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile 'E5\TemplateForSystemTopic\SystemTopicTemplate.json'


$paramNewAzEventGridSubscription = @{
    Endpoint              = $webHook.WebhookURI
    EventSubscriptionName = $eventSubscriptionName
    #ResourceGroupName     = $rgName
    IncludedEventType     = 'Microsoft.Resources.ResourceWriteSuccess'
    TopicName             = $systemTopicName
}

New-AzEventGridSubscription @paramNewAzEventGridSubscription