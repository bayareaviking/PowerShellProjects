#demonstrate debug mode
Return "This is a walk-through demo script file"

# https://docs.microsoft.com/powershell/scripting/dsc/troubleshooting/debugresource?view=powershell-5.1

#my demo configuration
psedit .\TestConfig.ps1

help Enable-DSCDebug

Clear-Host
#if using a virtual machine, snapshot the VM for a backup
# -BreakAll is mandatory
Enable-DscDebug -BreakAll -CimSession SRV1

#look at DebugMode property
Get-DscLocalConfigurationManager -CimSession SRV1

#push the configuration and debug

#recommend using -Wait and -Verbose
Start-DscConfiguration -Path C:\dscConfigs\DebugDemo -wait -verbose

#it may be helful to open the 2nd PowerShell session side-by-side
#follow on screen instructions to enter interactive debug session

<#
?
k
c
s
c
 # configuration may complete while still in debug mode
#>

#after finishing debugging
Disable-DSCDebug -CimSession SRV1
#verify
Get-DscLocalConfigurationManager -CimSession SRV1 |
Select-Object -property DebugMode