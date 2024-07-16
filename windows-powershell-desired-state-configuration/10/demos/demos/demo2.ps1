#demo partial configurations
# https://docs.microsoft.com/en-us/powershell/scripting/dsc/pull-server/partialconfigs

Return "This is a demo script file"

#region configure the LCM

psedit .\PartialLCM.ps1
. .\partialLCM.ps1
PartialConfig -Computername SRV1 -OutputPath c:\DSCConfigs\PartialDemo

Set-DscLocalConfigurationManager -Path C:\DSCConfigs\PartialDemo -Verbose
#back in Push mode
Get-DscLocalConfigurationManager -cimsession SRV1

#endregion

#region Deploy the partial configurations

psedit .\ServiceConfiguration.ps1
psedit .\FeaturesConfiguration.ps1

#load the configurations
. .\ServiceConfiguration.ps1
. .\FeaturesConfiguration.ps1

ServiceConfiguration -Computername SRV1 -OutputPath C:\DSCConfigs\ServiceConfiguration
FeaturesConfiguration -Computername SRV1 -OutputPath C:\DSCConfigs\FeaturesConfiguration

Publish-DscConfiguration -Path C:\DSCConfigs\FeaturesConfiguration -Verbose
Publish-DscConfiguration -Path C:\DSCConfigs\ServiceConfiguration -Verbose

Get-DscLocalConfigurationManager -cimsession SRV1

#apply with Start-DSCConfiguration and -UseExisting
Start-DscConfiguration -ComputerName SRV1 -Wait -UseExisting -Verbose

Clear-Host

#verify
Get-windowsfeature -ComputerName SRV1 | where installed
Test-DscConfiguration -ComputerName SRV1 -Detailed

#endregion