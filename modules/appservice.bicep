param location string = resourceGroup().location
param appServicePlanName string
param webAppName string
param environment string
param keyVaultName string

resource appPlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appPlan.id
    siteConfig: {
//       linuxFxVersion: 'NODE:18-lts'
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '18-lts'
        }
        {
          name: 'DB_USER'
          value: 'sqladmin'
        }
        {
          name: 'DB_PASSWORD'
          value: '@Microsoft.KeyVault(SecretUri=https://${keyVaultName}.vault.azure.net/secrets/sqlAdminPassword/)'
        }
        {
          name: 'DB_SERVER'
          value: 'sql-${environment}-iot.database.windows.net'
        }
        {
          name: 'DB_NAME'
          value: 'iotdb'
        }
      ]
    }
    httpsOnly: true
  }
}

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

// resource kvAccess 'Microsoft.KeyVault/vaults/accessPolicies@2023-02-01' = {
//   name: '${kv.name}/addPolicy'
//   properties: {
//     accessPolicies: [
//       {
//         tenantId: subscription().tenantId
//         objectId: webApp.identity.principalId
//         permissions: {
//           secrets: [
//             'get'
//           ]
//         }
//       }
//     ]
//   }
//     dependsOn: [
//         webApp
//     ]
// }
resource kvSecretReaderRole 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(webApp.id, 'KeyVaultSecretsUser')
  scope: kv
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6') // Key Vault Secrets User
    principalId: webApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
    dependsOn: [
        webApp
    ]
}


output webAppIdentity string = webApp.identity.principalId
