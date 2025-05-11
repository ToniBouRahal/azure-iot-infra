#!/bin/bash

set -e

RG=$1
IOTHUB_NAME=$2
KV_NAME=$3

echo "Fetching IoT Hub connection string..."
CONN=$(az iot hub connection-string show \
  --resource-group "$RG" \
  --hub-name "$IOTHUB_NAME" \
  --query connectionString -o tsv)

echo "Storing in IoT Hub Connection String in Key Vault..."
az keyvault secret set --vault-name "$KV_NAME" --name "iotHubConnectionString" --value "$CONN"

echo "Fetching IoT Hub shared access key..."
KEY=$(az iot hub connection-string show \
            --hub-name "$IOTHUB_NAME" \
            --resource-group "$RG" \
            --query connectionString -o tsv | awk -F'SharedAccessKey' '{print $3}' | sed 's/^=//')


echo "Storing Shared Access Key in Key Vault..."
az keyvault secret set --vault-name "$KV_NAME" --name "iotHubSharedAccessKey" --value "$KEY"
