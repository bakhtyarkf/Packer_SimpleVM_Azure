# this will create a rbac with default permisions that you can use to run the template
Param (
    $resourceGroup = "Packertest",
    $location = "westeurope"
)


if(Get-AzureRmResourceGroup -Name $resourceGroup) {
} else {
    New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Confirm:$true
}

$rbac=$(az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }")
$sid=$(az account show --query "{ subscription_id: id }")
$rbacObject = $rbac | ConvertFrom-Json
$sidObject =$sid | ConvertFrom-Json
$env:AZURE_PACKER_CLIENT_ID = $rbacObject.client_id
$env:AZURE_PACKER_CLIENT_SECRET = $rbacObject.client_secret
$env:AZURE_PACKER_TENANT_ID = $rbacObject.tenant_id
$env:AZURE_SUBSCRIPTION_ID = $sidObject.subscription_id
$env:AZURE_PACKER_RG = $resourceGroup
$env:AZURE_PACKER_LOCATION = $location
.\packer.exe build .\Azure.Ubuntu.Template.json