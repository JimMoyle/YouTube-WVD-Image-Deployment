param (
    [object]$WebHookData
)

if ($WebHookData) {
    $requestBody = $WebHookData.requestBody | ConvertFrom-Json

    $output = [PSCustomObject]@{
        Subject          = $requestBody.Subject
        EventType        = $requestBody.eventType
        Operation        = $requestBody.data.operationName
        Name             = $requestBody.data.claims.Name
        ResourceProvider = $requestBody.data.resourceProvider
        Status           = $requestBody.data.status
        PrincipleId      = $requestBody.data.authorization.evidence.principalId
    }

    Write-Output $output

}
else {
    Write-Output 'no data'
}