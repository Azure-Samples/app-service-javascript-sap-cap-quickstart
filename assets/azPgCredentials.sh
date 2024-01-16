#!/bin/bash

# find the .env file in the folder starting with ".azure"
searchPath=$(pwd)/.azure
AZENV_FILE=$(find $searchPath -name '.env')

# source it for prepopulated env vars
. $AZENV_FILE

# this is from the az env setup done previously
serverName="$COSMOSDB_CLUSTER_NAME-c"

# Call cosmos DB API to get the FQDN to compose the connection string
FQDN=$(az cosmosdb postgres cluster server show --server-name $serverName --cluster-name $COSMOSDB_CLUSTER_NAME --resource-group $AZURE_RESOURCE_GROUP --subscription $AZURE_SUBSCRIPTION_ID --query "fullyQualifiedDomainName" -o tsv)
sed -i -e "s/POSTGRES_HOSTNAME=.*/POSTGRES_HOSTNAME=$FQDN/g" $(pwd)/.env

# Read Cosmos DB password from the Azure Key Vault
CosmosDBpwd=$(az keyvault secret show --name $AZURE_KEY_VAULT_COSMOS_SECRET_NAME --vault-name $AZURE_KEY_VAULT_NAME --query "value" -o tsv)
sed -i -e "s/POSTGRES_USERPWD=.*/POSTGRES_USERPWD=$CosmosDBpwd/g" $(pwd)/.env
