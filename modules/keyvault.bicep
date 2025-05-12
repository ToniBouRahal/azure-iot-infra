param location string = resourceGroup().location
param name string
param environment string

@secure
param param spObjectId string

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: name
  location: location
  properties: {
    enableSoftDelete: false
    enablePurgeProtection: true
    enabledForTemplateDeployment: true
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: spObjectId
        permissions: {
          keys: [ 'all' ]
          secrets: [ 'all' ]
          certificates: [ 'all' ]
          storage: [ 'all' ]
        }
      }
    ]
  }
}

output keyVaultUri string = 'https://${kv.name}.vault.azure.net/'
