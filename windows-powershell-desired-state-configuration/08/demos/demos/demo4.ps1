#DSC configuration documents

Return "This is a walk-through demo script file"

#Manually re-apply the current configuration
Start-DscConfiguration -Wait -force -ComputerName SRV1 -UseExisting -verbose

#Remove an existing document
#Sometimes a configuration will fail or hang in a pending state
Remove-DscConfigurationDocument -Stage pending -Force -CimSession srv1

#Remove the previous configuration document
Remove-DscConfigurationDocument -Stage previous -Force -CimSession srv1

#Remove the current configuration document
Remove-DscConfigurationDocument -Stage current -Force -CimSession srv1

#Rollback using previous.mof if it exists
Restore-DscConfiguration -CimSession SRV1 -Verbose

