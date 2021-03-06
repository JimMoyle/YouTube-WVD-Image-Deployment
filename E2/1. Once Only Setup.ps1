#Define variables
# Azure region
$location = 'WestEurope'
# Your Azure Subscription ID
$subscriptionID = (Get-AzContext).Subscription.Id
# Destination image resource group name
$imageResourceGroup = 'YTAzureImageBuilderRG'
$imageResourceGroup = 'Episode5'

#Install AIB Pre-Release Modules
'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object { Install-Module -Name $_ -AllowPrerelease }

#Custom Azure Marketplace image verification function (find in E1)
. .\E1\Get-AzureImageInfo.ps1

#Register the following resource providers for use with your Azure subscription if they aren't already registered.
Register-AzProviderFeature -ProviderNamespace Microsoft.VirtualMachineImages -FeatureName VirtualMachineTemplatePreview -ErrorAction SilentlyContinue

Get-AzResourceProvider -ProviderNamespace Microsoft.Compute, Microsoft.KeyVault, Microsoft.Storage, Microsoft.VirtualMachineImages, Microsoft.Network |
    Where-Object RegistrationState -ne Registered |
    Register-AzResourceProvider


#Create a resource group
New-AzResourceGroup -Name $imageResourceGroup -Location $location

#Create user identity and set role permissions
#Grant Azure image builder permissions to create images in the specified resource group using the following example.
#Without this permission, the image build process won't complete successfully.

#Create variables for the role definition and identity names. These values must be unique. Removed random number addition as not necessary
# $randomNum = Get-Random -Minimum 100000 -Maximum 999999
$imageRoleDefName = 'YT Azure Image Builder Service Image Creation Role'# + $randomNum
$identityName = "YTAIBIdentity"# + $randomNum

#Create a user identity.
New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName

#Store the identity resource and principal IDs in variables.
$identity = Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName
Set-Content E2\TempFiles\identityNameId.txt $identity.Id
$identityNamePrincipalId = $identity.PrincipalId


#Assign permissions for identity to distribute images
#Download .json config file and modify it based on the settings defined in this article
$myRoleImageCreationUrl = 'https://raw.githubusercontent.com/danielsollondon/azvmimagebuilder/master/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json'
$myRoleImageCreationPath = "E2\myRoleImageCreation.json"

Invoke-WebRequest -Uri $myRoleImageCreationUrl -OutFile $myRoleImageCreationPath -UseBasicParsing

$Content = Get-Content -Path $myRoleImageCreationPath -Raw
$Content = $Content -replace '<subscriptionID>', $subscriptionID
$Content = $Content -replace '<rgName>', $imageResourceGroup
$Content = $Content -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName
$Content | Out-File -FilePath $myRoleImageCreationPath -Force

#Create the role definition.
New-AzRoleDefinition -InputFile $myRoleImageCreationPath
Start-Sleep -s 300 #this can take a few so sleep for a bit

#Grant the role definition to the image builder service principal.
$RoleAssignParams = @{
    ObjectId           = $identityNamePrincipalId
    RoleDefinitionName = $imageRoleDefName
    Scope              = "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"
}
New-AzRoleAssignment @RoleAssignParams

#Show role in Portal

#Create a Shared Image Gallery
#Create the gallery.

$myGalleryName = 'YTImageGalleryAIB'


New-AzGallery -GalleryName $myGalleryName -ResourceGroupName $imageResourceGroup -Location $location







