Return "This is a walk-through demo script file"

$s = New-PSSession -ComputerName SRV1
#configure TLS settings to connect to the PowerShell Gallery
Invoke-Command {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12} -session $s

#I'm turning off Write-Progress temporarily
Invoke-Command { $ProgressPreference = "silentlycontinue" } -session $s

# Invoke-Command {Install-Module ComputerManagementDSC,NetworkingDSC -force} -session $s
#This is revised code installing the proper version

Invoke-Command {
 Install-Module -Name ComputerManagementDSC -RequiredVersion 8.5.0 -force
 Install-Module -Name NetworkingDSC -RequiredVersion 8.2.0 -force
} -session $s

<#
Note - If you are using the PSAutolab module, it is possible you might see 2 instances
of ComputerManagementDSC. This is because PSAutolab uses a non-standard module
installation method. Ignore the fact that you see duplicate modules. In the real world
this should never happen.
#>
Invoke-Command {Get-Module -name ComputerManagementDSC,NetworkingDSC -ListAvailable} -session $s
Invoke-Command {Get-DSCResource HostsFile,SMBShare} -session $s | Select-Object Name,ModuleName,Version

#clean up the PSSession
Remove-PSSession $s

Clear-Host
