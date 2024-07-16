#DSC Event Logs

Return "This is a walk-through demo script file"

Get-WinEvent -ListLog *DSC* -ComputerName SRV2
#see hidden/disabled logs
Get-WinEvent -ListLog *DSC* -ComputerName SRV2 -force

Get-WinEvent -LogName Microsoft-Windows-DSC/Operational -ComputerName SRV2 -MaxEvents 10
Get-WinEvent -ProviderName microsoft-windows-dsc -MaxEvents 10 -ComputerName srv2

#use filtering
#errors = 2
#warnings = 3
#information = 4
Get-WinEvent -FilterHashtable @{Logname = 'Microsoft-Windows-DSC/Operational';Level='2'} -ComputerName srv1 -MaxEvents 20

#analytic logs
wevtutil.exe set-log Microsoft-Windows-Dsc/Analytic /q:true /e:true

#do something

$s = @{
    DestinationPath = "C:\work"
    ensure = "Present"
    Type = "directory"
}

Invoke-DscResource -name File -ModuleName PSDesiredStateConfiguration -Method Get -Property $s -Verbose

#check the log
Get-WinEvent -LogName Microsoft-Windows-DSC/Analytic -Oldest | 
Format-Table TimeCreated,LevelDisplayName,Message -wrap

#disable the log when finished
wevtutil.exe set-log Microsoft-Windows-Dsc/Analytic /q:true /e:false