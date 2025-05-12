param name string
param location string

@secure()
param twilioAccountSid string

@secure()
param twilioAuthToken string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
 //   definition: json(loadTextContent('../workflow-definition.json'))
    definition: {}
    parameters: {
    }
  }
}



output logicAppId string = logicApp.id
