#configure node LCM to be in pull mode

Return "This is a walk-through demo script file"

#region Configure the node's LCM

#need the guid of the corresponding MOF
$id = (Get-ChildItem C:\dscConfigs\PulledConfig\*.mof).BaseName
$id

#Use the id $id in the LCM configuration
#I'm using a parameter
psedit .\PullLCM.ps1

#load PullLCM
. .\PullLCM.ps1

#create the meta.mof
PullLCM -computername SRV1 -ID $(Get-ChildItem C:\dscConfigs\PulledConfig\*.mof).BaseName -OutputPath C:\DSCConfigs\PullLCM

#configure the LCM on SRV1
Set-DscLocalConfigurationManager -Path C:\DscConfigs\PullLCM -Verbose -Force

#verify
Get-DscLocalConfigurationManager -CimSession SRV1 -ov l

$l | Select-Object -property ConfigurationDownloadManagers,ResourceModuleManagers,RefreshMode,CertificateID,PSComputername

Clear-Host

#endregion

#region prep demo

#remove one of the required modules for testing and demo purposes
Invoke-Command -ScriptBlock {
    Get-Module -FullyQualifiedName @{Modulename = "NetworkingDSC"; ModuleVersion = "8.2.0" } -ListAvailable |
    Uninstall-Module -Force
} -ComputerName SRV1

#make sure path is empty
Invoke-Command { Test-Path 'C:\Program Files\WindowsPowerShell\Modules\networkingdsc' } -comp SRV1
# Invoke-Command { Get-Childitem 'C:\Program Files\WindowsPowerShell\Modules\networkingdsc' -recurse } -comp SRV1
# Invoke-Command { Remove-Item 'C:\Program Files\WindowsPowerShell\Modules\networkingdsc' -Force -Recurse } -comp SRV1

Clear-Host
#endregion

#region update the node to pull the new configuration

Update-DscConfiguration -Verbose -Wait -ComputerName SRV1

Get-DscConfigurationStatus -CimSession SRV1 | Select-Object -property *

Clear-Host
#endregion

#region troubleshooting failed demos

#these are things to try if the demo fails
Start-DscConfiguration -UseExisting -Wait -Verbose -Force -ComputerName srv1

Invoke-Command -ScriptBlock {
    Get-Module -FullyQualifiedName @{Modulename = "NetworkingDSC"; ModuleVersion = "8.2.0" } -ListAvailable
} -ComputerName SRV1

#update configuration and resources with new checksums and push to SRV2

#endregion