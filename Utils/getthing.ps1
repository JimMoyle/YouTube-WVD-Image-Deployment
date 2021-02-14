    $regex = '.*PACKER OUT     azure-arm: \$password = \"(\w*)\"'
    $text = Get-Content "C:\Windows\temp\*.ps1"
    Write-Output $text
    ($text | Select-String -Pattern $regex).Matches.Value -match $regex #| Out-Null
    Write-Output $Matches[1]