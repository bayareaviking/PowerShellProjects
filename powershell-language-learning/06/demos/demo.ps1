Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#casting to type
#PowerShell is can make educated guesses
$d = '12/31/2022'
$d
$d - (Get-Date)
$d | Get-Member

[datetime]$d = '12/31/2022'
$d - (Get-Date)

#type operators -IS and -AS
$i = '10'
$i * $i

$i -is [int32]
$i -is [string]
$i -as [int32]
($i -as [int32]) * 3

"1.0" -as [version]
[version]$v = "1.0.0"
$v

Remove-Variable d
$d = "12/31/2022"
($d -as [datetime]) - (Get-Date)

#here is a trick
$d
$d.GetType()
#This is just another object
$d.GetType().Name

cls

#using dotted notation
$p = Get-Process -Id $pid
$p
$p | Get-Member -MemberType Properties
$p.id
$p.path

#view all properties
$p | Select-Object -Property *

#you can extend the dotted notation
#visualization is a big help
$p.modules
$p.modules.modulename

#here's a cool trick
$all = Get-Process
$all.Name

cls

#don't assume what you see is what you get
# Install-Module PSTeachingTools -force
Get-Vegetable
Get-Vegetable | Select-Object Name, State, Count
Get-Vegetable | Get-Member
Get-Vegetable corn | Select-Object *
Get-Vegetable | Select-Object Name, CookedState, Count

#this happens often in PowerShell
Get-WinEvent -LogName system -MaxEvents 1 -OutVariable e
$e | Get-Member
Get-WinEvent -LogName System -MaxEvents 10 | Select-Object Logname, LevelDisplayName, ProviderName, MachineName

#You can use any property you discover
Get-WinEvent -LogName system -MaxEvents 1000 | Group-Object -Property LevelDisplayName

cls

#invoking object methods
notepad
$n = Get-Process notepad
$n | Get-Member -MemberType methods
$n.CloseMainWindow()
Get-Process notepad
#look for cmdlets that invoke methods

cls

$n = "fred", "betty", "wilma", "barney"
$n[0] | Get-Member ToUpper
$n | ForEach-Object { $_.ToUpper() }

#this will also work
$n.ToUpper()

#some methods have parameters
$n[0] | Get-Member substring

$n | ForEach-Object { "$($_.substring(0,1).ToUpper())$($_.Substring(1))" }

#we'll look at other ways to manipulate strings in the next module

cls