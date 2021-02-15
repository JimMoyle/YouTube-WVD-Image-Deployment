function Get-AibLogFile {
    param(
        [string]$StorageAccountName,
        [string]$TargetPath = 'c:\jimm\customization.log'
    )
    $continue = $true
    While ($continue) {
        $r = Get-AzResourceGroup -Tag @{createdby = 'AzureVMImageBuilder' }
        $s = Get-AzStorageAccount -ResourceGroupName $r.ResourceGroupName -Name $StorageAccountName
        $p = Get-AzStorageContainer -Context $s.context | Where-Object { $_.Name -eq 'packerlogs' }
        $container = Get-AzStorageBlob -Container $p.Name -Context $s.context
        $fileLoc = Get-AzStorageBlobContent -Container $p.Name -Context $s.context -Blob $container.Name -Destination 'c:\jimm' -Force -ErrorAction SilentlyContinue
        Copy-Item ( Join-Path 'c:\jimm' $fileLoc.name) $TargetPath -Force -ErrorAction SilentlyContinue
        $content = Get-Content -Path $TargetPath -Tail 1
        if ($content -like "*Done exporting Packer logs to Azure Storage.") {
            $continue = $false
            Write-Output $content
        }
    }
}


