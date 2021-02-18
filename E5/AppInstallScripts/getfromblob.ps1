$audience = 'https://storage.azure.com'
$token = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$audience" -Headers @{ 'Metadata' = 'true' }

$storageAccountName = 'episodefive'
$containerName = 'aib-blob', 'applicationblob', 'blob-aib'
foreach ($container in $containerName) {
    $blob = "https://$storageAccountName.blob.core.windows.net/$container/tasks.txt"
    $auth = "$($token.token_type) $($token.access_token)"
    Invoke-RestMethod -Method GET -Uri $blob -Verbose -Headers @{
        'Authorization' = $auth
        'x-ms-version'  = '2019-02-02'
    }
}