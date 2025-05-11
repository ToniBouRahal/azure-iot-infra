#!/bin/bash

set -e

RG=$1
EH_NAMESPACE=$2
KV_NAME=$3

echo "Fetching Event Hub connection string..."
CONN=$(az eventhubs namespace authorization-rule keys list \
  --resource-group "$RG" \
  --namespace-name "$EH_NAMESPACE" \
  --name RootManageSharedAccessKey \
  --query primaryConnectionString -o tsv)

echo "Fetching Event Hub shared access key..."
KEY=$(az eventhubs namespace authorization-rule keys list \
  --resource-group "$RG" \
  --namespace-name "$EH_NAMESPACE" \
  --name RootManageSharedAccessKey \
  --query primaryConnectionString -o tsv | awk -F'SharedAccessKey' '{print $2}')

echo "Storing in Key Vault..."
az keyvault secret set --vault-name "$KV_NAME" --name "eventHubConnectionString" --value "$CONN"
az keyvault secret set --vault-name "$KV_NAME" --name "eventHubSharedAccessKey" --value "$KEY"
