param serverGroupName string
param location string
param tags object = {}

@secure()
param administratorLoginPassword string


// PostgreSQL version
param version string

resource serverGroup 'Microsoft.DBforPostgreSQL/serverGroupsv2@2022-11-08' = {
  name: serverGroupName
  location: location
  tags: tags
  properties: {
    administratorLoginPassword: administratorLoginPassword
    nodeCount: 0
    coordinatorVCores: 1
    nodeVCores: 4
    nodeEnablePublicIpAccess: true
    coordinatorEnablePublicIpAccess: true
    coordinatorServerEdition: 'BurstableMemoryOptimized' //GeneralPurpose
    coordinatorStorageQuotaInMb: 32768 //131072
    nodeServerEdition: 'MemoryOptimized'
    nodeStorageQuotaInMb: 524288 //524288
    postgresqlVersion: version
  }
}
//Allow all IP addresses to access the server for initial setup. This needs to be changed for production environments.
resource AllConnectionsAllowed 'Microsoft.DBforPostgreSQL/serverGroupsv2/firewallRules@2022-11-08' = {
  name: 'AllConnectionsAllowed'
  parent: serverGroup
  properties: {
    endIpAddress: '255.255.255.255'
    startIpAddress: '0.0.0.0'
  }
}

resource AllAzureServicesAllowed 'Microsoft.DBforPostgreSQL/serverGroupsv2/firewallRules@2022-11-08' = {
  name: 'AllAzureServicesAllowed'
  parent: serverGroup
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

output id string = serverGroup.id
output name string = serverGroup.name
