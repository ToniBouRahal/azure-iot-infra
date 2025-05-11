param name string
param location string

@secure()
param eventHubAccessKey string

param serviceBusNamespace string
param eventHubName string
param iotHubNamespace string

@secure()
param sqlAdminPassword string

@secure()
param iotHubAccessKey string

resource job 'Microsoft.StreamAnalytics/streamingjobs@2020-03-01' = {
  name: name
  location: location
  properties: {
//     jobType: 'StreamingJob'
    sku: {
      name: 'Standard'
    }
    eventsOutOfOrderPolicy: 'Adjust'
    outputErrorPolicy: 'Drop'
    eventsOutOfOrderMaxDelayInSeconds: 0
    eventsLateArrivalMaxDelayInSeconds: 5
    dataLocale: 'en-US'
    compatibilityLevel: '1.2'
    transformation: {
      name: 'streamTransformation'
      properties: {
        streamingUnits: 1
        query: '''
          SELECT * INTO sqloutput FROM iotinput;

          SELECT DeviceId, Temperature, Humidity, Pressure, Timestamp
          INTO ehoutput
          FROM iotinput
          WHERE Temperature > 45 OR Humidity > 90 OR Pressure < 960;
        '''
      }
    }
  }
}

resource inputIoT 'Microsoft.StreamAnalytics/streamingjobs/inputs@2020-03-01' = {
  name: '${job.name}/iotinput'
  properties: {
    type: 'Stream'
    datasource: {
      type: 'Microsoft.Devices/IotHubs'
      properties: {
        iotHubNamespace: iotHubNamespace
//         sharedAccessPolicyKey: iotHubConnectionString
        sharedAccessPolicyKey: iotHubAccessKey
        sharedAccessPolicyName: 'iothubowner'
        consumerGroupName: 'streamanalyticscg'
        endpoint: 'messages/events'
      }
    }
    serialization: {
      type: 'Json'
      properties: {
        encoding: 'UTF8'
      }
    }
  }
}

resource outputEH 'Microsoft.StreamAnalytics/streamingjobs/outputs@2020-03-01' = {
  name: '${job.name}/ehoutput'
  properties: {
    datasource: {
      type: 'Microsoft.ServiceBus/EventHub'
      properties: {
        eventHubName: eventHubName
        serviceBusNamespace: serviceBusNamespace
        sharedAccessPolicyName: 'RootManageSharedAccessKey'
        sharedAccessPolicyKey: eventHubAccessKey
      }
    }
    serialization: {
      type: 'Json'
      properties: {
        encoding: 'UTF8'
        format: 'LineSeparated'
      }
    }
  }
}

resource outputSQL 'Microsoft.StreamAnalytics/streamingjobs/outputs@2020-03-01' = {
  name: '${job.name}/sqloutput'
  properties: {
    datasource: {
      type: 'Microsoft.Sql/Server/Database'
      properties: {
        server: 'sql-dev-iot.database.windows.net'
        database: 'iotdb'
        user: 'sqladmin'
        password: sqlAdminPassword
        table: 'Telemetry'
      }
    }
    serialization: {
      type: 'Json'
      properties: {
        encoding: 'UTF8'
        format: 'LineSeparated'
      }
    }
  }
}

output streamJobName string = job.name
output sqlOutputName string = outputSQL.name
output eventHubOutputName string = outputEH.name
