param name string
param location string = resourceGroup().location

resource iotHub 'Microsoft.Devices/IotHubs@2021-07-02' = {
  name: name
  location: location
  sku: {
    name: 'S1'
    capacity: 1
  }
  properties: {
    enableFileUploadNotifications: false
  }
}

resource consumerGroup 'Microsoft.Devices/IotHubs/eventHubEndpoints/ConsumerGroups@2021-07-02' = {
  name: '${iotHub.name}/events/streamanalyticscg'
  properties: {
    name: 'cg1'
  }
  dependsOn: [
    iotHub
  ]
}


output iotHubName string = iotHub.name
output consumerGroupName string = consumerGroup.name
