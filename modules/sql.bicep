param location string
param sqlServerName string
param sqlDbName string
param adminUsername string
@secure()
param adminPassword string

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: sqlServerName
  location: location
//   location: 'northeurope'
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
  }
}

resource firewall 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview' = {
  name: '${sqlServer.name}/AllowAzure'
//   location: 'northeurope'
  location: location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  name: '${sqlServer.name}/${sqlDbName}'
  location: location
//   location: 'northeurope'
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
  }
  dependsOn: [
    sqlServer
  ]
}

output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
