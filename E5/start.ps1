$WebHookData = Get-Content D:\PoShCode\GitHub\YouTube-WVD-Image-Deployment\E5\3.json
$webHookData = $WebHookData | ConvertFrom-Json

$requestBody = $webHookData.requestBody | ConvertFrom-Json

$output = [PSCustomOBject]@{
    Subject          = $requestBody.Subject
    EventType        = $requestBody.eventType
    Name             = $requestBody.data.claims.Name
    ResourceProvider = $requestBody.data.resourceProvider
    Status           = $requestBody.data.status
}

Write-Output $output