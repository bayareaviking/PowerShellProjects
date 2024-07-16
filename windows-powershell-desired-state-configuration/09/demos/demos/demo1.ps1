#set up a pull server

Return "This is a walk-through demo script file"

# https://docs.microsoft.com/powershell/scripting/dsc/pull-server/enactingconfigurations?view=powershell-5.1
# setup an SMB share pull server: https://docs.microsoft.com/en-us/powershell/scripting/dsc/pull-server/pullserversmb?view=powershell-5.1
# setup an HTTP share pull server: https://docs.microsoft.com/powershell/scripting/dsc/pull-server/pullserver?view=powershell-5.1

#you may want to backup or snapshot the VM

#install xPSDesiredStateConfiguration module to use the xDscWebService resource
# https://github.com/dsccommunity/xPSDesiredStateConfiguration

# Install-Module xPSDesiredStateConfiguration -force
# Get-DSCresource -module xPSDesiredStateConfiguration
Get-DscResource xDscWebService -Syntax

# I am also using NetworkingDSC
# Get-Module NetworkingDSC -list
# Install-Module NetworkingDSC -force

#there is a sample configuration online in the Microsoft documentation
#My version is a bit more complete
psedit .\PullServerConfig.ps1

# using config data
psedit .\pullConfigData.psd1

#load the configuration
. .\PullServerConfig.ps1

#create the MOF
HTTPPullserver -ConfigurationData .\pullConfigData.psd1 -OutputPath C:\DSCConfigs\Pull

#make sure resources are installed on the Node
$mods = @(
    @{
        ModuleName = "NetworkingDSC"
        ModuleVersion = "8.2.0"
    },
        @{
        ModuleName = "xPSDesiredStateConfiguration"
        ModuleVersion = "9.1.0"
    }
)

Invoke-Command -scriptblock {
$using:mods | Foreach-Object {

 [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 if (-Not (Get-Module -FullyQualifiedName $_ -ListAvailable)) {
    write-Host "Installing $($_.ModuleName) $($_.ModuleVersion)" -foreground cyan
    Install-Module -Name $($_.ModuleName) -RequiredVersion $($_.ModuleVersion) -Repository PSGallery -Force
 }
 else {
    Write-host "Installing $($_.ModuleName) $($_.ModuleVersion) is installed" -foreground green
 }
}
} -computername SRV2

Clear-Host
Start-DscConfiguration -Wait -Verbose -Path c:\dscconfigs\pull -force

start http://srv2:8080/PSDSCPullServer.svc
Invoke-WebRequest -uri http://srv2:8080/PSDSCPullServer.svc -DisableKeepAlive -UseBasicParsing

Clear-Host
