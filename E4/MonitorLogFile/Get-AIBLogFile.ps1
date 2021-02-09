While ($true) {
    $r = Get-AzResourceGroup -Tag @{createdby = 'AzureVMImageBuilder' }
    $s = Get-AzStorageAccount | Where-Object { $_.ResourceGroupName -eq $r.ResourceGroupName }
    $p = Get-AzStorageContainer -Context $s.context | Where-Object { $_.Name -eq 'packerlogs' }
    $container = Get-AzStorageBlob -Container $p.Name  -Context $s.context
    $fileLoc = Get-AzStorageBlobContent -Container $p.Name  -Context $s.context -Blob $container.Name -Destination 'c:\jimm' -Force
    Copy-Item ( Join-Path 'c:\jimm' $fileLoc.name) 'c:\jimm\customization.log' -Force
}
