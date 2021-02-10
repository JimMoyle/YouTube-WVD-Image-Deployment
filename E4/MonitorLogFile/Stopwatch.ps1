$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
while ($true) { $stopwatch.Elapsed.ToString().SubString(0, 8); Start-Sleep 1; Clear-Host}