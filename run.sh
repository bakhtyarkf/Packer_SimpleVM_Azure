# this will create a rbac with default permisions that you can use to run the template
az group create -n $1 -l $2
rbac=$(az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }")
sid=$(az account show --query "{ subscription_id: id }")
export AZURE_PACKER_CLIENT_ID=$(jq '.client_id' <<< "$rbac" | sed 's/\"//g')
export AZURE_PACKER_CLIENT_SECRET=$(jq '.client_secret' <<< "$rbac" | sed 's/\"//g')
export AZURE_PACKER_TENANT_ID=$(jq '.tenant_id' <<< "$rbac" | sed 's/\"//g')
export AZURE_SUBSCRIPTION_ID=$(jq '.subscription_id' <<< "$sid" | sed 's/\"//g')
export AZURE_PACKER_RG=$1
export AZURE_PACKER_Location=$2