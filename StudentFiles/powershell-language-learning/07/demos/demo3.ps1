Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#demo common datetime techniques
help Get-Date

#case-sensitive
Get-Date -format g
Get-Date -format G
Get-Date -format u
# unix format
Get-Date -uformat "%Y_%m"

#you can create a date
$a = "1/1/2022 2:15PM"
Get-Date $a
$b = Get-Date -Year 2022 -Month 1 -Date 31
$b
$b | Select-Object *
$b | Get-Member -MemberType methods

$b.IsDaylightSavingTime()
$b.ToLongDateString()

#these are methods you are likely to use
$b | Get-Member add*
$b.AddDays(45)
$b.AddHours(1000)
#easier to use a negative number
$b.AddMonths(-5)

#timespans
[datetime]$c="6/11/2022 6:00PM"

help New-TimeSpan
$ts = New-TimeSpan -Start $b -End $c
$ts
$ts.Days

#or subtract
$c - $b

#timespans usually and automatically displayed as strings
$ts.ToString()

cls

#practical examples
$in = "*.ps1","*.psm1","*.psd1","*.txt","*.xml","*.json"

Get-Childitem c:\scripts -file -Recurse -include $in |
Group-Object -Property {$_.CreationTime.Year} |
Select-Object -Property Count,@{Name="Year";Expression={$_.Name}},
@{Name="Size";Expression = {($_.Group | Measure-Object -property length -sum).sum}},
@{Name="Lines";Expression = {($_.Group | Get-Content | Measure-Object -Line -ignoreWhitespace).Lines}} |
Format-Table -GroupBy @{Name="Path";Expression={"C:\Scripts"}} -AutoSize

cls