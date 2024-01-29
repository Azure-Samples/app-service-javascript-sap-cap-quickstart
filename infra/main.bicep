targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

// Optional parameters to override the default azd resource naming conventions. Update the main.parameters.json file to provide values. e.g.,:
// "resourceGroupName": {
//      "value": "myGroupName"
// }
param apiServiceName string = ''
param applicationInsightsDashboardName string = ''
param applicationInsightsName string = ''
param appServicePlanName string = ''
param keyVaultName string = ''
param logAnalyticsName string = ''
param resourceGroupName string = ''
param cosmosAccountName string = ''

@description('Resource Group containing the existing API Management instance')
param apimResourceGroupName string = 'DEMO-NEU-SAP-PM1'

@description('Name of the API Management service instance')
param apimServiceName string = 'demo-sap-apim'

@description('Target URL of the SAP backend API fronted by the existing API Management')
param apimApiSAPBackendURL string = 'https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap/API_BUSINESS_PARTNER'

@description('Flag to use Azure API Management to mediate the calls between the Web frontend and the SAP backend API')
param useAPIM bool = false

@description('Entra ID Application ID registered for Azure API Management. Needed to automatically assign API executing rights to Azure App Service.')
param apimEntraIdAppId string = ''//'********-****-****-****-************'

@description('Flag to use Entra ID authentication feature of Azure App Service')
param useEntraIDAuthentication bool = false

// Name of the SKU; default is F1 (Free), use B1 (Basic) for features like health checks and S1 (Standard) for production
@description('Name of the SKU of the App Service Plan')
param skuName string = 'B1'

@description('Id of the user or app to assign application roles')
param principalId string = ''

// App specific parameters - provide the values via the main.parameters.json referencing e.g. environment parameters
@description('SAP OData service URL')
param oDataUrl string = 'https://sandbox.api.sap.com/s4hanacloud'

@description('SAP client for OData service')
param oDataSapClient string = ''

@description('SAP OData user name')
param oDataUsername string = ''

@description('SAP OData user password')
@secure()
param oDataUserpwd string = ''

@description('API Key')
@secure()
param _APIKey string = ''

@description('API Key Header Name')
param ApiKeyHeaderName string = 'APIKey'

@description('Ignore Entra ID flag. Needed for API key only scenarios with Entra ID authentication enabled. True for the default S/4HANA Cloud sandbox scenario for instance.')
param _Ignore_Entra_ID_Token bool = true

var abbrs = loadJsonContent('./abbreviations.json')
var tags = { 'azd-env-name': environmentName }

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

module app './app.bicep' = {
  scope: rg
  name: 'app-deployment'
  params: {
    environmentName: environmentName
    location: location
    apiServiceName: apiServiceName
    applicationInsightsDashboardName: applicationInsightsDashboardName
    applicationInsightsName: applicationInsightsName
    appServicePlanName: appServicePlanName
    keyVaultName: keyVaultName
    logAnalyticsName: logAnalyticsName
    cosmosAccountName: cosmosAccountName
    useEntraIDAuthentication: useEntraIDAuthentication
    skuName: skuName
    principalId: principalId
    oDataUrl: oDataUrl
    oDataSapClient: oDataSapClient
    oDataUsername: oDataUsername
    oDataUserpwd: oDataUserpwd
    _APIKey: _APIKey
    ApiKeyHeaderName: ApiKeyHeaderName
    _Ignore_Entra_ID_Token: _Ignore_Entra_ID_Token
  }
}


//Reference the existing API Management instance from another resource group but same subscription
resource apimrg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = if (useAPIM){
  name: apimResourceGroupName
  scope: subscription()
}

module apimApi './app/apim-api.bicep' = if (useAPIM) {
  scope: apimrg
  name: 'apim-api-deployment'
  params: {
    name: apimServiceName
    apiName: 'api-business-partner'
    apiDisplayName: 'API_BUSINESS_PARTNER SAP'
    apiDescription: 'Business Partner residing on SAP ERP exposed via OData'
    apiPath: 'sdk/sap/opu/odata/sap/API_BUSINESS_PARTNER'
    apiBackendUrl: apimApiSAPBackendURL
    applicationInsightsName: app.outputs.MONITORING_APPINSIGHTS_NAME
    applicationInsightsRG: rg.name
    //apiAppName: api.outputs.SERVICE_API_NAME
  }
}

// App outputs
output AZURE_RESOURCE_GROUP string = rg.name
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId


output WEB_APP_NAME string = app.outputs.WEB_APP_NAME
output USE_EntraIDAuthentication bool = app.outputs.USE_EntraIDAuthentication

output AZURE_KEY_VAULT_NAME string = app.outputs.AZURE_KEY_VAULT_NAME
output AZURE_KEY_VAULT_ENDPOINT string = app.outputs.AZURE_KEY_VAULT_ENDPOINT
output AZURE_KEY_VAULT_COSMOS_SECRET_NAME string = app.outputs.AZURE_KEY_VAULT_COSMOS_SECRET_NAME
output AAD_KV_SECRET_NAME string = app.outputs.AAD_KV_SECRET_NAME
output COSMOSDB_CLUSTER_NAME string = app.outputs.COSMOSDB_CLUSTER_NAME
//TODO: Consolidate following two properties?
output APPLICATIONINSIGHTS_CONNECTION_STRING string = app.outputs.APPLICATIONINSIGHTS_CONNECTION_STRING
output SAP_CLOUD_SDK_API_APPLICATIONINSIGHTS_CONNECTION_STRING string = app.outputs.SAP_CLOUD_SDK_API_APPLICATIONINSIGHTS_CONNECTION_STRING

output USE_APIM bool = useAPIM
output AZURE_APIM_NAME string = apimServiceName
output AZURE_APIM_APP_ID string = apimEntraIdAppId

output SAP_CLOUD_SDK_API_URL array = useAPIM ? [ apimApi.outputs.SERVICE_API_URI, app.outputs.SERVICE_API_URI ]: [app.outputs.SERVICE_API_URI]
