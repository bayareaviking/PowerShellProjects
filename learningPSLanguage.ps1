# Scriptblocks
#$sb1 = { Get-Service | where {$_.status -eq 'running'} }
#& $sb1

$sb2 = {
    param($log, $count)
    Get-WinEvent -LogName $log -MaxEvents $count -Verbose
}

#& $sb2 system 2 | Format-List ProviderName,ID,LevelDisplayName,Message
Invoke-Command -ScriptBlock $sb2 -ArgumentList System, 2 | Format-List ProviderName, ID, LevelDisplayName, Message 

# Objects
$d = '12/31/2022'
$d - $(Get-Date)