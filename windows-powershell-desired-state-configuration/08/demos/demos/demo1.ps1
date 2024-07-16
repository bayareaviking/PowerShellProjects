#testing DSC status

Return "This is a walk-through demo script file"

#known issues
# https://docs.microsoft.com/powershell/scripting/windows-powershell/wmf/known-issues/known-issues-dsc?view=powershell-5.1

#DSC configuration files are found here
dir C:\windows\system32\configuration
# but use cmdlets where possible

#all past configuration events are found here:
dir C:\windows\system32\Configuration\ConfigurationStatus

help Get-DscConfigurationStatus
Get-DscConfigurationStatus -CimSession SRV1
Get-DscConfigurationStatus -CimSession SRV1 | Select-Object -property *
Get-DscConfigurationStatus -CimSession SRV1 -all | Group-Object -Property Type

#status history is maintained in: C:\windows\system32\Configuration\DSCStatusHistory.mof
#you may get LCM errors if this file gets too large

#testing technically only shows compliance but it might be helpful
help Test-DscConfiguration
Test-DscConfiguration -ComputerName SRV1
Test-DscConfiguration -ComputerName SRV1 -Detailed -ov t
$t.resourcesInDesiredState

