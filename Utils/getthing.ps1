param(
    $path = 'C:\jimm'
)

foreach ($file in Get-ChildItem C:\jimm\customization.log -File) { $rx = '\$password = \".\w*\"'; (Get-Content $file | Select-String -Pattern $rx).ToString()}
<#
$regex = '.*PACKER OUT     azure-arm: \$password = \"(\w*)\"'
$files =  Get-ChildItem -path "c:\Windows\temp" -File -Filter *.ps1
Write-Output $files
$text = $files | Get-Content
Write-Output $text
($text | Select-String -Pattern $regex).Matches.Value -match $regex #| Out-Null
Write-Output $Matches[1]
#>