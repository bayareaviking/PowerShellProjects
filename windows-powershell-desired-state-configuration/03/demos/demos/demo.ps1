#run this is in the same folder as the sample.ps1
$PSVersionTable
whoami
whoami /groups /fo csv | convertfrom-csv | Sort 'Group Name' | select 'Group name'
cls
get-content .\Sample.ps1
#run the configuration
. .\Sample.ps1
#the path does not exist
Invoke-Command { Test-Path c:\DSCDemo} -computername SRV1
#generate the configuration file
sample
#push the configuration
Start-DscConfiguration -path C:\Sample -verbose -Wait
Get-DscConfiguration -CimSession SRV1
Get-DscLocalConfigurationManager -CimSession SRV1
Invoke-Command { Test-Path c:\DSCDemo} -computername SRV1
cls

#reset
# Invoke-Command { Remove-Item c:\DSCDemo -force -recurse} -computername SRV1