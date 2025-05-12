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
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      'contentVersion': '1.0.0.0'
      'parameters': {}
      'triggers': {
        'manualTrigger': {
          'type': 'Request'
          'kind': 'Http'
          'inputs': {
            'schema': {}
          }
        }
      }
      'actions': {
        'response': {
          'type': 'Response'
          'inputs': {
            'statusCode': 200
            'body': {
              'message': 'Hello from Logic App!'
            }
          }
        }
      }
      'outputs': {}
    }
    parameters: {
    }
  }
}



output logicAppId string = logicApp.id
