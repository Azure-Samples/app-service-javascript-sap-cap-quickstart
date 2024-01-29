targetScope = 'resourceGroup'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param apiServiceName string = ''
param applicationInsightsDashboardName string = ''
param applicationInsightsName string = ''
param appServicePlanName string = ''
param keyVaultName string = ''
param logAnalyticsName string = ''
param cosmosAccountName string = ''

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
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }

module passwordgen './core_local/security/password-gen.bicep' = {
  name: 'password-generator'
  params: {
    location: location
  }
}

// The application database
module cosmos './core_local/database/cosmos/postgresql/cosmos-psql-db.bicep' = {
  name: 'cosmos'
  params: {
    serverGroupName: !empty(cosmosAccountName) ? cosmosAccountName : '${abbrs.dBforPostgreSQLServers}${resourceToken}'
    location: location
    tags: tags
    version: '16'
    administratorLoginPassword: passwordgen.outputs.result
  }
}

var cosmosDBSecretName = '${abbrs.keyVaultVaults}secret-cosmosdb-password'
var myAppSettings = {
  ODATA_URL: oDataUrl
  SAP_CLIENT: oDataSapClient
  ODATA_USERNAME: oDataUsername
  ODATA_USERPWD: '@Microsoft.KeyVault(SecretUri=${keyVault.outputs.endpoint}secrets/${abbrs.keyVaultVaults}secret-odata-password)'
  APIKEY: '@Microsoft.KeyVault(SecretUri=${keyVault.outputs.endpoint}secrets/${abbrs.keyVaultVaults}secret-apikey)'
  APIKEY_HEADERNAME: ApiKeyHeaderName
  POSTGRES_HOSTNAME: ''
  POSTGRES_USERPWD: '@Microsoft.KeyVault(SecretUri=${keyVault.outputs.endpoint}secrets/${cosmosDBSecretName})'
  IGNORE_ENTRA_ID_TOKEN: _Ignore_Entra_ID_Token
  AADAPPSETTINGSECRET: '@Microsoft.KeyVault(SecretUri=${keyVault.outputs.endpoint}secrets/${abbrs.keyVaultVaults}secret-aad-appsetting-secret)'
}

// The application backend
module api './app/api.bicep' = {
  name: 'api'
  params: {
    name: !empty(apiServiceName) ? apiServiceName : '${abbrs.webSitesAppService}api-${resourceToken}'
    location: location
    tags: tags
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    appServicePlanId: appServicePlan.outputs.id
    keyVaultName: keyVault.outputs.name
    appSettings: myAppSettings
    useAuthSettingsv2: useEntraIDAuthentication
    use32BitWorkerProcess: skuName == 'F1' || skuName == 'FREE' || skuName == 'SHARED' ? true : false
    alwaysOn: skuName == 'F1' || skuName == 'FREE' || skuName == 'SHARED' ? false : true
  }
}

// Give the API access to KeyVault
module apiKeyVaultAccess './core/security/keyvault-access.bicep' = {
  name: 'api-keyvault-access'
  params: {
    keyVaultName: keyVault.outputs.name
    principalId: api.outputs.SERVICE_API_IDENTITY_PRINCIPAL_ID
  }
}

// Create an App Service Plan to group applications under the same payment plan and SKU
module appServicePlan './core/host/appserviceplan.bicep' = {
  name: 'appserviceplan'
  params: {
    name: !empty(appServicePlanName) ? appServicePlanName : '${abbrs.webServerFarms}${resourceToken}'
    location: location
    tags: tags
    sku: {
      name: skuName
    }
  }
}

// Store secrets in a keyvault
module keyVault './core/security/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    name: !empty(keyVaultName) ? keyVaultName : '${abbrs.keyVaultVaults}${resourceToken}'
    location: location
    tags: tags
    principalId: principalId
  }
}

// Store OData Password in KeyVault
module oDataPassword './core/security/keyvault-secret.bicep' = {
  name: 'odatapassword'
  params: {
    name: '${abbrs.keyVaultVaults}secret-odata-password'
    keyVaultName: keyVault.outputs.name
    tags: tags
    secretValue: oDataUserpwd
  }
}

var appSecretSettingName = '${abbrs.keyVaultVaults}secret-aad-appsetting-secret'
// Create value for Entra ID app secret that gets filled via azd postprovision hook
module aadAppRegistrationSecret './core/security/keyvault-secret.bicep' = if (useEntraIDAuthentication) {
  name: 'aadappregsecret'
  params: {
    name: appSecretSettingName
    keyVaultName: keyVault.outputs.name
    tags: tags
    secretValue: ''
  }
}

// Store API key in KeyVault
module ApiKey './core/security/keyvault-secret.bicep' = {
  name: 'apikey'
  params: {
    name: '${abbrs.keyVaultVaults}secret-apikey'
    keyVaultName: keyVault.outputs.name
    tags: tags
    secretValue: _APIKey
  }
}

// Store CosmosDB secret in KeyVault
module cosmosDBPassword './core/security/keyvault-secret.bicep' = {
  name: 'cosmosdbpassword'
  params: {
    name: cosmosDBSecretName
    keyVaultName: keyVault.outputs.name
    tags: tags
    secretValue: passwordgen.outputs.result
  }
}

// Monitor application with Azure Monitor
module monitoring './core/monitor/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    tags: tags
    logAnalyticsName: !empty(logAnalyticsName) ? logAnalyticsName : '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    applicationInsightsName: !empty(applicationInsightsName) ? applicationInsightsName : '${abbrs.insightsComponents}${resourceToken}'
    applicationInsightsDashboardName: !empty(applicationInsightsDashboardName) ? applicationInsightsDashboardName : '${abbrs.portalDashboards}${resourceToken}'
  }
}

// App outputs
output AZURE_RESOURCE_GROUP string = resourceGroup().name
output APPLICATIONINSIGHTS_CONNECTION_STRING string = monitoring.outputs.applicationInsightsConnectionString
output AZURE_KEY_VAULT_ENDPOINT string = keyVault.outputs.endpoint
output AZURE_KEY_VAULT_NAME string = keyVault.outputs.name
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output USE_EntraIDAuthentication bool = useEntraIDAuthentication
output AAD_KV_SECRET_NAME string = appSecretSettingName
output WEB_APP_NAME string = api.outputs.SERVICE_API_NAME
output COSMOSDB_CLUSTER_NAME string = cosmos.outputs.name
output AZURE_KEY_VAULT_COSMOS_SECRET_NAME string = cosmosDBSecretName
output SERVICE_API_URI string = api.outputs.SERVICE_API_URI
output SAP_CLOUD_SDK_API_APPLICATIONINSIGHTS_CONNECTION_STRING string = monitoring.outputs.applicationInsightsConnectionString

output MONITORING_APPINSIGHTS_NAME string = monitoring.outputs.applicationInsightsName
