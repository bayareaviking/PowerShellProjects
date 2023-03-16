Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#creating a scriptblock
$sb = { Get-Service | Where-Object { $_.status -eq 'running' } }

#running a scriptblock

& $sb

Invoke-Command $sb

#used everywhere
#typically in scripts
Get-Process | Where-Object { $_.ws –ge 100MB } | Select-Object ID, Name, WS

$new = @{
    Path     = "C:\Work"
    ItemType = "Directory"
    Force    = $True
}

1..10 |
ForEach-Object {
    New-Item -Name "Data-$_" @new
}

#with parameters
$sb = { Param($log, $count) Get-WinEvent -LogName $log -MaxEvents $count }

&$sb system 2 | Format-List ProviderName, ID, LevelDisplayName, Message

Invoke-Command -ScriptBlock $sb -ArgumentList System, 2

Start-Job {
    param($log, $count)
    Get-WinEvent -FilterHashtable @{Logname = $log; SuppressHashFilter = @{Level = 4}} -MaxEvents $count |
    Group-Object ProviderName -NoElement |
    Sort-Object Count -Descending
} -ArgumentList System, 1000 -Name LogInfo

Receive-Job loginfo -Keep | Format-Table -AutoSize

#eventually you'll create functions
Function Get-LogInfo {
    param($log, $count)
    Get-WinEvent -FilterHashtable @{
        Logname            = $log
        SuppressHashFilter = @{Level = 4}
    } -MaxEvents $count |
    Group-Object ProviderName -NoElement |
    Sort-Object Count -Descending
}
