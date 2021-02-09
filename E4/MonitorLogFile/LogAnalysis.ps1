$l = Get-Content -Path "C:\Users\jsmoy\Downloads\customization (9).log"
$out = $l | Where-Object { $_ -like "*PACKER OUT*"}
$out | Set-Content 'c:\jimm\packer.log'