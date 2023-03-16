Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#demo common string techniques

$s = "PowerShell"
$s | Get-Member

#one property
$s.Length

#strings can also be treated as an array
$s[0]
$s[3..6]

#case
$s.ToLower()
$s.toUpper()
#doesn't change the variable
$s

#parsing
#substring
$s.Substring.OverloadDefinitions
#start counting at 0
$s.Substring(5)
$s.Substring(0,5)
#remember, the method is writing an object
$s.Substring(5).toupper()

cls

#trim
$t = " Pluralsight   "
$t
$t.length
$t.TrimEnd()
$t.TrimStart()
$r = $t.trim()
$r
$r.length

cls

#you might need to clean-up date
$f = "c:\work\computers.txt"
Get-Content $f

#some commands can handle misformatted values
Get-Content $f | Test-Connection -IPv4 -Count 1
Get-Content $f |
ForEach-Object { $_.length -gt 0 ? (Test-Connection -IPv4 -Count 1 -computername $_.Trim()) : (Write-Warning "Skipping blank")}

#this might be better
Get-Content $f |
Where-Object {$_.length -gt 0} |
Foreach-object {Test-Connection -IPv4 -Count 1 -computername $_.Trim()}
cls

#replace
$s

#method
#we have this string
$s.Replace.OverloadDefinitions
$s.replace("e",3)
#original doesn't change
$s
#case-sensitive
#sometimes you don't know what the data will be
$s.replace("p","X")
$s.replace("p","X","OrdinalIgnoreCase")

#you can combine
$s.Replace("o","()").replace("e","<").Replace("h","&")

#operator is case-insensitive
$s -replace "p","!"
#can also use regex
"jeff789" -replace "\d","X"

cls

#an example
$data = "art | deco |1234|Sales"
$arr = $data.split("|").Trim()
$arr
#using arrays
$arr[0][0]

#technically a string element is a [CHAR] so it needs to
#be converted to a string first
$name = @()
$name+= $arr[0].replace($arr[0][0],$arr[0][0].toString().ToUpper())
$name+= $arr[1].replace($arr[1][0],$arr[1][0].toString().ToUpper())
$name
Write-Host "Creating user $($name -join ' ')" -ForegroundColor yellow

#take your time to follow what PowerShell is doing

cls

