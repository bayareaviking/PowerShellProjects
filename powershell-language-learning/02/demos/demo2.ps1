Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

# How to use Variables in PowerShell
# $a = 2
# Get-Vegetable | Select-Object -First $a
# $a = 5
#I'll use the variable a and save the results to variable b
# $b = Get-Process | Select-Object -First $a
# $b | Select-Object Name

#now you can use the results without having to re-run Get-Process
# $b | Sort-Object ws -Descending | Select-Object name,ws
# $b | select id,name,handles

#saving time
$logs = Get-WinEvent -LogName system -MaxEvents 1000
$logs | Group-Object LevelDisplayName -NoElement
$logs | Group-Object ProviderName -NoElement
$logs |
Where-Object { $_.providername -EQ 'service control manager' } |
Select-Object TimeCreated, LevelDisplayName, Message

Clear-Host

#sometimes the variable will change
$veg = Get-Vegetable c*
$veg
Set-Vegetable corn -Count 1 -Passthru
$veg

#but sometimes not
$bits = Get-Service BITS
$bits | Select-Object name, StartType

Set-Service bits -StartupType Disabled -PassThru |
Select-Object name, StartType

#variable is unchanged
$bits.StartType

#reset
# Set-service bits -StartupType Manual
Clear-Host

#type
$a = 2
$a | Get-Member
$a + $a

#be careful
$i = '5'
#sometimes the PowerShell host will know what you mean
$i + $i
$i | Get-Member

# cast to type
[int32]$i = 10
$i * 2

[datetime]$d = "12/31/2022"
$d
$d | Get-Member

#but be careful

$d = "foo"
#either remove the variable or re-define
[string]$d = "foo"
$d
#or be careful of your variable names and usages

Clear-Host

#a slightly advanced alternative
$t = "12/12/2022 10:00 AM"
$t
$t | Get-Member
$t -as [datetime]
#doesn't change $t
$t.Length

Clear-Host

