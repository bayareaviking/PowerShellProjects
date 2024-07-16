#make sure you are running latest versions of PowerShellGet and PackageManagement
Get-Module PowerShellGet -ListAvailable
Get-Module PackageManagement -ListAvailable

cls
#it can be tricky finding resources.
#here I know in advance the resource
Find-DSCResource -name smbShare

Find-Module computermanagementdsc | Tee-Object -Variable m
$m | Format-Table author,publisheddate,projecturi,description -wrap
$m.additionalmetadata.DscResources

#install the modules on the authoring box
Install-Module ComputerManagementDSC -force

Get-DSCresource smbshare -syntax

cls

#wildcards don't really work
Find-DscResource -name hosts
Find-DSCResource -filter "hosts"
Find-DscResource -name hostsfile

Install-Module NetworkingDSC -force
cls

#look the configuration using these resources
# powershell_ise .\basicServer.ps1
