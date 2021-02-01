    $paramNewAzGalleryImageDefinition = @{
        GalleryName       = "YTImageGalleryAIB"
        ResourceGroupName = 'YTAzureImageBuilderRG'
        Location          = 'westeurope'
        Name              = '20h2-evd-o365pp'
        OsState           = 'generalized'
        OsType            = 'Windows'
        Publisher         = 'MicrosoftWindowsDesktop'
        Offer             = 'office-365'
        Sku               = '20h2-evd-o365pp'
    }
    New-AzGalleryImageDefinition @paramNewAzGalleryImageDefinition