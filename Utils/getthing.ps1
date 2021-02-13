    $regex = '.*PACKER OUT     azure-arm: \$password = \"(\w*)\"'
    $text = Get-Content "c:\windows\temp\*.ps1"
    ($text | Select-String -Pattern $regex).Matches.Value -match $regex #| Out-Null
    Write-Output $Matches[1]