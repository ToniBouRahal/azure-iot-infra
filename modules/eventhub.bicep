param name string
param location string = resourceGroup().location
param sku string = 'Standard'
param capacity int = 1
param eventHubName string
param consumerGroupName string = 'functioncg'

resource ehNamespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  name: name
  location: location
  sku: {
    name: sku
    tier: sku
    capacity: capacity
  }
  properties: {
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2022-10-01-preview' = {  // ✅ Fixed
  name: '${name}/${eventHubName}'
  properties: {
    messageRetentionInDays: 1
    partitionCount: 2
  }
    dependsOn: [
    ehNamespace
  ]
}

resource consumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2022-10-01-preview' = {
  name: '${name}/${eventHubName}/${consumerGroupName}' // ✅ Matches 3-part type
  properties: {}
    dependsOn: [
        eventHub
    ]
}

resource authRule 'Microsoft.EventHub/namespaces/authorizationRules@2022-10-01-preview' = {
  name: '${name}/RootManageSharedAccessKey'
  properties: {
    rights: [
      'Listen'
      'Send'
      'Manage'
    ]
  }
    dependsOn: [
        consumerGroup
    ]
}

output eventHubNamespaceName string = ehNamespace.name
output eventHubName string = eventHub.name
output consumerGroup string = consumerGroup.name
