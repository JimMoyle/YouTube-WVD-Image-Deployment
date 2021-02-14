    $regex = '.*PACKER OUT     azure-arm: \$password = \"(\w*)\"'
    $text = Get-ChildItem -path "c:\Windows\temp" -File -Filter *.ps1 | Get-Content
    Write-Output $text
    ($text | Select-String -Pattern $regex).Matches.Value -match $regex #| Out-Null
    Write-Output $Matches[1]