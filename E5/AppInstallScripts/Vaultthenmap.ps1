$audience = 'https://vault.azure.net'
$token = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$audience" -Headers @{ 'Metadata' = 'true' }

$vaultName = 'EpisodeFiveVault'
$secretName = 'EpisodeFiveStorage'

$secret = "https://$vaultName.vault.azure.net/secrets/$secretName/?api-version=7.0"
$auth = "$($token.token_type) $($token.access_token)"
$userPassword = (Invoke-RestMethod -Method GET -Uri $secret -Headers @{ 'Authorization' = $auth }).value


$storageAcctName = 'episodefive'


$driveMap = [pscustomobject]@{
    Drive = 'S'
    Folder = 'featuresondemand'
},[pscustomobject]@{
    Drive = 'T'
    Folder = 'localexperience'
}


$target = $storageAcctName + '.file.core.windows.net'
#$target = '10.1.0.5'

$userName = Join-Path 'Azure' $storageAcctName

$password = ConvertTo-SecureString $userPassword -AsPlainText -Force

$Cred = New-Object System.Management.Automation.PSCredential ($userName, $password)

$driveMap | ForEach-Object {

    Remove-PSDrive -Name $_.Drive -Force

    $path = Join-Path $target $_.Folder

    $connectTestResult = Test-NetConnection -ComputerName $target -Port 445
    if ($connectTestResult.TcpTestSucceeded) {
        New-PSDrive -PSProvider FileSystem -Root ('\\' + $path) -Credential $cred -Name $_.Drive
    }
    else{
        Write-Output "Could not connect to $path"
    }
}
