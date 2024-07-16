#demo using Script Resource
# run in the scripting editor
Return "This is a walk-through demo script file"
psedit .\RSATConfig.ps1

. .\RSATConfig.ps1

rsatconfig -OutputPath c:\DscConfigs\rsatdemo
psedit C:\Dscconfigs\rsatdemo\WIN10.mof

#I'll remove a feature to demonstrate
Invoke-Command {
    Remove-WindowsCapability -Online -Name 'Rsat.DHCP.Tools~~~~0.0.1.0'
    Remove-WindowsCapability -Online -Name 'Rsat.Dns.Tools~~~~0.0.1.0'
} -ComputerName WIN10

Start-DscConfiguration -Path C:\DscConfigs\rsatdemo -Wait -Verbose -Force
Test-DscConfiguration -CimSession win10 -Detailed
Get-DscConfiguration -CimSession win10

psedit .\RSATConfig2.ps1

. .\RSATConfig2.ps1

$feat = @(
    'Rsat.FileServices.Tools~~~~0.0.1.0',
    'Rsat.ServerManager.Tools~~~~0.0.1.0'
)
rsatconfig2 -rsatFeatures $feat -OutputPath c:\DSCConfigs\rsatdemo2
psedit C:\DscConfigs\rsatdemo2\WIN10.mof

#I'll remove a feature to demonstrate
Invoke-Command {
    Remove-WindowsCapability -Online -Name 'Rsat.DHCP.Tools~~~~0.0.1.0'
    Remove-WindowsCapability -Online -Name 'Rsat.Dns.Tools~~~~0.0.1.0'
} -ComputerName WIN10

Start-DscConfiguration -Path C:\dscConfigs\rsatdemo2 -Wait -Verbose -Force
Test-DscConfiguration -CimSession win10 -Detailed
Get-DscConfiguration -CimSession win10

