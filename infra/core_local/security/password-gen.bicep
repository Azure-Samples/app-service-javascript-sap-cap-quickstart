param utcValue string = utcNow()
param location string = resourceGroup().location
// Generate admin password for the CosmosDB instance
resource runPowerShellInlineWithOutput 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'runPowerShellInlineWithOutput'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    forceUpdateTag: utcValue
    azPowerShellVersion: '10.4'
    scriptContent: '''
    $charlist = [char]94..[char]126 + [char]65..[char]90 + [char]47..[char]57
    $PasswordProfile = ($charlist | Get-Random -count 66) -join ''
    Write-Output $PasswordProfile
    $DeploymentScriptOutputs = @{}
    $DeploymentScriptOutputs["text"] = $PasswordProfile
    '''
    timeout: 'PT1H'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
}

output result string = runPowerShellInlineWithOutput.properties.outputs.text
