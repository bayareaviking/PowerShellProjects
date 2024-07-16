Return "This is a walk-through demo script file"

#run in the scripting editor

#Create a folder for my configs
if (-Not (Test-Path c:\DSCConfigs)) {
    New-Item -ItemType Directory -path C:\ -name DSCConfigs
}

#dot source the file
. .\BasicServer.ps1

#run the configuration to generate the MOF
BasicServer -outputpath c:\DSCConfigs

#current LCM settings
Get-DscLocalConfigurationManager -CimSession SRV1

#configure the LCM
Set-DscLocalConfigurationManager -path c:\DSCConfigs -verbose
#verify
Get-DscLocalConfigurationManager -CimSession SRV1

Clear-Host

#start the configuration
Start-DscConfiguration -path c:\DSCConfigs -Wait -Verbose
