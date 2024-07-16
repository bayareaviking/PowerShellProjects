# see https://docs.microsoft.com/en-us/powershell/scripting/dsc/pull-server/reportserver

Return "This is a walk through demo"

#region build your own

psedit .\DSCConfigReport.ps1

.\DSCConfigReport.ps1 -Cimsession Srv1 -verbose
Invoke-Item .\SRV1.html

#endregion

#region configuring for the reporting server

#reporting requires a Pull server with registration key
#redeploy pull server adding registration key
psedit .\PullServerConfig.ps1
. .\PullServerConfig.ps1
HTTPPullServer -ConfigurationData .\pullConfigData.psd1 -OutputPath C:\dscconfigs\PullServer
Start-DscConfiguration -Path C:\dscconfigs\PullServer -Verbose -Wait

#node configuration
psedit .\RunPulledConfig.ps1
. .\RunPulledConfig.ps1 -Computername SRV1 -verbose 

Clear-Host

#endregion

#region getting report data

$srv1 = Get-DscLocalConfigurationManager -CimSession srv1
$srv1 | Select-Object PSComputername, ReportManagers, AgentID
$agentID = $srv1.AgentId
$serviceUrl = $srv1.ReportManagers.serverURL
#BE CAREFUL WITH CASE
$requestURI = "$serviceURL/Nodes(AgentId='$agentid')/Reports"

$get = @{
  Uri             = $requestURI
  ContentType     = "application/json;odata=minimalmetadata;streaming=true;charset=utf-8"
  UseBasicParsing = $True
  Headers         = @{Accept = "application/json"; ProtocolVersion = "2.0" }
}
$data = Invoke-WebRequest @get

$data.content

$json = ConvertFrom-Json $data.Content
$json.value.count
$json.value[0]
$json.value[0].StatusData | ConvertFrom-Json

foreach ($item in $json.value) {
  $item | Select-Object OperationType, Status,
  @{Name = "Start"; Expression = { $_.StartTime -as [datetime] } },
  @{Name = "End"; Expression = { $_.EndTime -as [datetime] } },
  RebootRequested,
  @{Name = "Mode"; Expression = { ($_.StatusData | ConvertFrom-Json).mode } },
  @{Name = "Computername"; Expression = { ($_.StatusData | ConvertFrom-Json).hostname } }
}

Clear-Host
#I wrote a PowerShell function
psedit .\DSCReporting.ps1

. .\DSCReporting.ps1

Get-DSCReportSummary SRV1 -verbose

#you could also generate an odata proxy
# help Export-ODataEndpointProxy

#endregion

#region community tools

#DSCEA
# https://microsoft.github.io/DSCEA/
# Install-Module DSCEA -force
# Import-Module DSCEA
# Get-Command -module DSCEA
# Start-DSCEAscan -CimSession srv1 -MofFile C:\DSCConfigs\pulledconfig2\cf245fdd-334f-4c32-819d-c70b5d0c2c90.mof
# Get-DSCEAreport -ComputerName SRV1
Invoke-Item .\ComputerComplianceReport-SRV1.html

#DSCPullServerAdmin

#https://github.com/bgelens/DSCPullServerAdmin
# This runs ON the pull server and you need to stop DSCService
# or run the module commands on the local copy of devices.edb

Enter-PSSession Srv2 #-Credential company\artd

# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Install-Module DSCPullServerAdmin -force

Get-Command -module DSCPullServerAdmin

#you could copy data to another SQL Server

Set-Location 'C:\Program Files\WindowsPowerShell\DscService'

Get-ChildItem

Get-Website PSDSCPullServer | Select ApplicationPool
Stop-WebAppPool -name (Get-Website PSDSCPullServer).ApplicationPool

#connect to the database file
New-DSCPullServerAdminConnection -ESEFilePath .\devices.edb

#registered devices
Get-DSCPullServerAdminRegistration
Get-DSCPullServerAdminDevice
Get-DSCPullServerAdminStatusReport | Tee-Object -Variable r
$r | Group NodeName

$last = $r | where nodename -eq 'srv1' | sort LastModifiedTime | Select -last 1
$last
$last.StatusData
$last.StatusData.resourcesInDesiredState

#close the database connection
Remove-DSCPullServerAdminConnection -Connection (Get-DSCPullServerAdminConnection)

#restart the web site
Start-WebAppPool -name (get-website PSDSCPullServer).ApplicationPool

Exit

#endregion