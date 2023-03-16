Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#demo array fundamentals
$a = 1..10
$a
#we'll cover -is later in the course
$a -is [array]

#a case where the variables DOES have its own meaning
$a.count
#ven though the contents are integers
$a | Get-Member

cls

$b = "foo", "bar", "abra", "ca", "dabra"
$b.Count

#reference by index number
$b[0]
$b[1]
#start at the end
$b[-1]
$b[-2]

#or you can do this:
$b[1..3]
cls

#create an empty array
$c = @()

$c += "localhost"
$c += $env:computername
$c += "srv2"
$c

#this doesn't work
Test-WSMan -ComputerName $c
#why?
help test-wsman -Parameter computername
help test-connection -Parameter targetname

#test the command
Test-Connection localhost -IPv4 -Count 1
cls

#can't remove items from an array
#but you can re-define
#this is not the only way you could do this

Test-Connection -TargetName $c -IPv4 -Count 1 |
Where-Object { $_.status -eq 'success' } |
ForEach-Object -Begin { $c = @() } -Process {
    $c += $_.Destination
} -End { Write-Host "testing complete" -foreground cyan }


#what is in $c now?
$c

help about_arrays

cls