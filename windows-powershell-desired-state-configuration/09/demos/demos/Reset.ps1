#This is my reset file to re-publish and re-push
#I used this to troubleshoot and revise my demos

Clear-Host

Write-Host "clearing folders"  -ForegroundColor yellow
dir C:\dsc\PulledConfig | del
dir C:\dsc\PullLCM | del

write-Host "re-publish configuration"  -ForegroundColor yellow
. .\PulledConfig.ps1

PulledConfig -output C:\DSC\PulledConfig
$id = New-Guid
$new = Join-Path -path C:\dsc\PulledConfig -ChildPath "$id.mof"
Rename-Item C:\dsc\PulledConfig\Localhost.mof -NewName $new -PassThru
New-DscChecksum -Path $New -OutPath C:\dsc\PulledConfig -Force
$config = Import-PowerShellDataFile .\pullConfigData.psd1

$srv2 = New-PSSession -computername SRV2
Write-Host "Clearing ConfigurationPath on SRV2" -foregroundcolor Yellow
invoke-command { dir $using:config.allnodes[1].PullServerConfigurationPath -file | del } -session $srv2
copy C:\dsc\PulledConfig\* -Destination $config.allnodes[1].PullServerConfigurationPath -ToSession $srv2 -force

Write-Host "re-publish resources"  -ForegroundColor yellow
If (-Not (Test-Path C:\ModuleExports)) {
    New-Item -path C: -Name ModuleExports -ItemType Directory
}

Write-Host "create archive zip file and checksum"  -ForegroundColor yellow
. .\CreateFlatZip.ps1
Import-csv .\moduledata.csv | Export-DSCResourceModule -OutputPath C:\ModuleExports -passthru
Copy-Item C:\ModuleExports\* -Destination $config.allnodes[1].PullServerModulePath -ToSession $srv2 -Force

Remove-PSSession $srv2

Write-Host "remove NetworkingDSC module from SRV1" -ForegroundColor yellow
Invoke-Command -ScriptBlock {
 Get-Module -FullyQualifiedName @{Modulename = "NetworkingDSC";ModuleVersion = "8.2.0"} -ListAvailable |
 Uninstall-Module -Force
 if (Test-Path 'C:\Program Files\WindowsPowerShell\Modules\networkingdsc') {
    Remove-Item 'C:\Program Files\WindowsPowerShell\Modules\networkingdsc' -Force -Recurse
 }
} -ComputerName SRV1

Write-Host "re-set client LCM" -ForegroundColor yellow
. .\PullLCM.ps1
PullLCM -computername SRV1 -ID $(Get-Childitem C:\dsc\PulledConfig\*.mof).BaseName -OutputPath C:\DSC\PullLCM

write-host "Resetting configuration settings on SRV1"
Invoke-Command { 
    if (Test-path c:\stuff) { remove-item c:\stuff -Recurse -force}
    Set-Service Winmgmt -StartupType Manual
} -computername Srv1

Write-Host "configure the LCM on SRV1" -ForegroundColor yellow
Set-DscLocalConfigurationManager -Path C:\dsc\PullLCM -Verbose -force

Get-DscLocalConfigurationManager -CimSession SRV1

Update-DscConfiguration -Wait -Verbose -ComputerName SRV1