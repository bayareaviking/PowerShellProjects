Return "This is a walk-through demo script file"

#run in the scripting editor

#using PowerShell
Get-SmbShare -CimSession SRV1
Get-ChildItem \\srv1\DemoFiles
Get-WindowsFeature powershell-v2 -ComputerName srv1
Invoke-Command {Get-Content $env:systemroot\system32\drivers\etc\hosts} -ComputerName srv1

Clear-Host

#using DSC cmdlets
Get-DSCConfigurationStatus -cimsession SRV1
Test-DscConfiguration -CimSession SRV1 -Detailed | Format-List
#break the configuration
invoke-command { del c:\dscdemo\*.*} -comp srv1
#re-test
Test-DscConfiguration -CimSession SRV1 -Detailed 
#Because the LCM is set to ApplyAndAutoCorrect, the missing file will be
#recreated

Clear-Host

<#
Takeaways
Setting the LCM is a separate task from the configuration
Use -verbose and -wait
Otherwise, use the job cmdlets to monitor

#>