foreach ($file in Get-ChildItem c:\windows\temp -File -Filter *.ps1){$rx = '\$password = \".\w*\"';(Get-Content $file | Select-String -Pattern $rx).ToString()}
<#
$regex = '.*PACKER OUT     azure-arm: \$password = \"(\w*)\"'
$files =  Get-ChildItem -path "c:\Windows\temp" -File -Filter *.ps1
Write-Output $files
$text = $files | Get-Content
Write-Output $text
($text | Select-String -Pattern $regex).Matches.Value -match $regex #| Out-Null
Write-Output $Matches[1]
#>