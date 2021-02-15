param(
    $path = 'C:\jimm'
)

foreach ($file in Get-ChildItem C:\jimm\customization.log -File) { $rx = '\$password = \".\w*\"'; (Get-Content $file | Select-String -Pattern $rx).ToString() }
<#
{
    "type": "PowerShell",
    "runElevated": true,
    "name": "get ps1",
    "inline": [
        "Write-Output 'getting powershell files'",
        "gci -path c:\\Windows\\temp -File -Filter *.ps1",
        "gci -path c:\\Windows\\temp -File -Filter *.ps1 | get-content",
        "Write-Output 'Done powershell files'"
    ]
},
#>