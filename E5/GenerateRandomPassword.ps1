
$length = 16

$password = -join ((33, 35) + (36..38) + (42..44) + (48..57) + (60..90) + (91..94) + (97..122)
    | Get-Random -Count $length
    | ForEach-Object { [char]$_ })

Write-Output $password