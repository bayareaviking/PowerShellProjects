#demo named configurations
#this demo assumes you have setup SRV2 as a pull server
#you may want to snapshot lab vms before running this demo

Return "This is a demo script file"

# https://docs.microsoft.com/powershell/scripting/dsc/pull-server/pullclientconfignames?view=powershell-5.1

#region create the named configuration

psedit .\BasicServer.ps1
. .\BasicServer.ps1
BasicCompanyServer -computername SRV1 -OutputPath C:\DSCConfigs\BasicCompanyServer

#rename
#make sure no previous file exists
If (Test-Path "C:\DSCConfigs\BasicCompanyServer\BasicCompanyServer.mof") {
    Remove-Item "C:\DSCConfigs\BasicCompanyServer\BasicCompanyServer.mof"
}
Rename-Item -Path C:\DSCConfigs\BasicCompanyServer\SRV1.mof -NewName BasicCompanyServer.mof -PassThru

#checksum
New-DscChecksum -Path C:\DSCConfigs\BasicCompanyServer\BasicCompanyServer.mof -force

#endregion

#region deploy the configuration to the pull server
$sess = New-PSSession -ComputerName SRV2
$paramHash = @{
 Path = "C:\DSCConfigs\BasicCompanyServer\BasicCompanyServer.*"
 Destination = "C:\Program Files\WindowsPowerShell\DscService\Configuration"
 Force = $True
 ToSession = $Sess
}

Copy-Item @paramHash
#verify
Invoke-Command { Get-ChildItem "C:\Program Files\WindowsPowerShell\DscService\Configuration"} -session $sess

#endregion

#region RegistrationKey

#this only works with a web pull server
#need a shared secret stored on the pull server
$myRegKey = (New-Guid).guid

#save to a file. Protect it.
Set-Content -Path C:\DSCConfigs\RegistrationKeys.txt -Value $myRegKey

$paramhash.Path = "C:\DSCConfigs\RegistrationKeys.txt"
$paramHash.destination = "c:\Program Files\WindowsPowerShell\DscService"
Copy-item @paramhash

Invoke-Command -scriptblock { Get-ChildItem "c:\Program Files\WindowsPowerShell\DscService"} -session $sess

Remove-PSSession $sess

#endregion

#region configure the node

psedit .\NamedLCM.ps1
. .\NamedLCM.ps1

$splat = @{
 ComputerName = "SRV1"
 RegistrationKey = $(Get-Content C:\DSCConfigs\RegistrationKeys.txt) 
 OutputPath = "C:\DSCConfigs\NamedConfig"
}
NamedConfigLCM @splat

Set-DscLocalConfigurationManager -Path $splat.OutputPath -ComputerName $splat.Computername -Force -Verbose

#endregion

#region Update the node

Get-DscLocalConfigurationManager -CimSession SRV1 | Tee-Object -Variable lcm
#verify the named configuration
$lcm.ConfigurationDownloadManagers

Update-DscConfiguration -ComputerName SRV1 -Verbose -wait

Get-DscConfigurationStatus -CimSession SRV1
Get-DscConfiguration -CimSession SRV1

#endregion
