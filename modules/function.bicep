param location string
param functionAppName string
param storageAccountName string
param appServicePlanName string

@secure()
param eventHubConnection string

param eventHubName string

@secure()
param logicAppEndpoint string

resource plan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  properties:{
    reserved: true
  }
  sku: {
    name: 'EP1'
    tier: 'ElasticPremium'
  }
  kind: 'linux'
}

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}

resource funcApp 'Microsoft.Web/sites@2023-01-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  identity: { type: 'SystemAssigned' }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      pythonVersion: '3.11'
      appSettings: [
        { name: 'FUNCTIONS_WORKER_RUNTIME', value: 'python' },{name: 'FUNCTIONS_EXTENSION_VERSION', value: '~4'},{ name: 'EVENTHUB_CONNECTION', value: eventHubConnection },{ name: 'EVENTHUB_NAME', value: eventHubName },{ name: 'LOGICAPP_ENDPOINT', value: logicAppEndpoint }
    ]
  }
}
}
