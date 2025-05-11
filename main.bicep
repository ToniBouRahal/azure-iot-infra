param environment string = 'dev'
param location string = resourceGroup().location

@secure()
param twilioAccountSid string

@secure()
param twilioAuthToken string

@secure()
param iotHubConnectionString string

@secure()
param eventHubConnectionString string

@secure()
param sqlAdminPassword string

@secure()
param sqlConnectionString string

@secure()
param logicAppEndpoint string

@secure()
param iotHubAccessKey string

@secure()
param eventHubAccessKey string

param keyVaultName string = 'kv-${environment}-iot-003'
param iotHubName string = 'iothub-${environment}-002'
param eventHubNamespaceName string = 'eh-${environment}-iot-002'
param eventHubName string = 'telemetry-events'
param streamJobName string = 'sa-${environment}-job-002'
param sqlServerName string = 'sql-${environment}-iot-002'
param sqlDbName string = 'iotdb'
param sqlAdminUsername string = 'sqladmin'
param logicAppName string = 'la-${environment}-alerts-002'
param functionAppName string = 'func-${environment}-alerts-002'
param storageAccountName string = 'iotfunc${environment}storage-002'
param appServicePlanName string = 'webapp-plan-${environment}-002'
param webAppName string = 'iotweb-${environment}-002'
param eventHubConsumerGroup string = 'functioncg'




// module keyvault 'modules/keyvault.bicep' = {
//   name: 'keyvault-deploy'
//   params: {
//     location: location
//     name: keyVaultName
//     environment: environment
//   }
// }

// module iothub 'modules/iothub.bicep' = {
//   name: 'iothub-deploy'
//   params: {
//     name: iotHubName
//     location: location
//   }
// }

// module eventhub 'modules/eventhub.bicep' = {
//   name: 'eventhub-deploy'
//   params: {
//     name: eventHubNamespaceName
//     location: location
//     eventHubName: eventHubName
//     consumerGroupName: eventHubConsumerGroup
//   }
// }
//
// module streamanalytics 'modules/streamanalytics.bicep' = {
//   name: 'streamanalytics-deploy'
//   params: {
//     name: streamJobName
//     location: location
//     iotHubAccessKey: iotHubAccessKey
//     iotHubNamespace: iotHubName
//     eventHubAccessKey: eventHubAccessKey
//     serviceBusNamespace: eventhub.outputs.eventHubNamespaceName
//     eventHubName: eventHubName
//     sqlAdminPassword: sqlAdminPassword
//   }
// }
//
// module sql 'modules/sql.bicep' = {
//   name: 'sqldb-deploy'
//   params: {
//     location: location
//     sqlServerName: sqlServerName
//     sqlDbName: sqlDbName
//     adminUsername: sqlAdminUsername
//     adminPassword: sqlAdminPassword
//   }
// }
//
// module logicapp 'modules/logicapp.bicep' = {
//   name: 'logicapp-deploy'
//   params: {
//     name: logicAppName
//     twilioAccountSid: twilioAccountSid
//     twilioAuthToken: twilioAuthToken
//     location: location
//   }
// }

module function 'modules/function.bicep' = {
  name: 'functionapp-deploy'
  params: {
    location: location
    functionAppName: functionAppName
    storageAccountName: storageAccountName
    appServicePlanName: 'func-plan-${environment}'
    eventHubConnection: eventHubConnectionString
    eventHubName: eventHubName
    logicAppEndpoint: logicAppEndpoint
  }
}
//
// module webapp 'modules/appservice.bicep' = {
//   name: 'webapp-deploy'
//   params: {
//     location: location
//     appServicePlanName: appServicePlanName
//     webAppName: webAppName
//     environment: environment
//     keyVaultName: keyVaultName
//   }
// }
