Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#custom objects and properties
#be sure to look at help examples for Select-Object

# Get-ChildItem -path C:\data –file -recurse |
# Select-Object -property Fullname,Name,LastWriteTime,
# @{Name = "Size";Expression = {$_.Length}},
# @{Name = "Computername";Expression = {$env:computername}},
# @{Name = "Audit";Expression = {(Get-Date –format g)}} |
# Export-CSV c:\work\data.csv

#using Select-Object
Get-TimeZone
Get-TimeZone | Select-Object *, @{Name = "Computername"; Expression = { $env:computername } }

Get-Process | Where-Object { $_.ws –ge 50MB } |
Select-Object ID, Name,
@{Name = "MemoryMB"; Expression = { ($_.ws / 1mb) -as [int32] } },
@{Name = "Threads"; Expression = { $_.threads.count } },
@{Name = "Runtime"; Expression = { (Get-Date) - ($_.Starttime) } } |
Format-Table

#this is why you want to read cmdlet help and examples
1..10 | Sort-Object -Property { $_ % 2 }

#there are a few ways this could be written

Get-ChildItem c:\scripts -Directory |
Sort-Object -Property { (Get-ChildItem $_.fullname -File -Recurse).count } -Descending |
Select-Object -First 5

Get-ChildItem c:\scripts\*.ps1 | Group-Object -Property { $_.LastWriteTime.year }

cls

#creating custom objects with hashtables

#Custom objects
#look at help for new-object
$ps = Get-CimInstance win32_process
$svc = Get-CimInstance win32_service -Filter "status = 'running'"

$hash = @{
    Computername = $env:computername
    Version      = $PSVersionTable.PSVersion
    ProcessCount = $ps.count
    ServiceCount = $svc.count
    Uptime       = Get-Uptime
}

$hash

New-Object -TypeName PSObject -Property $hash | tee -v new

$new | Get-Member

cls

#using [pscustomobject]
$obj = [pscustomobject]@{
    Computername = $env:computername
    Version      = $PSVersionTable.PSVersion
    ProcessCount = $ps.count
    ServiceCount = $svc.count
    TimeZone     = (Get-TimeZone).DisplayName
    Uptime       = Get-Uptime
}

#property order is maintained
$obj

cls

#let's revisit an earlier example
#these techniques used more often in scripting
$procs = Get-Process | Where-Object { $_.ws –ge 50MB }

foreach ($p in $procs) {
    [pscustomobject]@{
        ID           = $p.Id
        Name         = $p.Name
        MemoryMB     = ($p.ws / 1mb) -as [int32]
        Threads      = $p.threads.count
        Runtime      = (Get-Date) - ($p.Starttime)
        Computername = $env:computername
    }
}


cls

#summary
# Always be thinking about working with objects
# Look for ways to take advantage of dotted notation
# When you start scripting you can create custom and rich objects
# that you can use in PowerShell.