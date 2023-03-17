Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#demo working with arrays

$n = "Foo","Bar","#","%",1,5,7,"!","Alpha","Omega"
$n
#you can have different types
$n | Get-Member

cls

#test for containment
#not case-sensitive
$n -contains "FOO"
$n -contains "xyz"
#or test if it doesn't contain
$n -notcontains "xyz"

#you can also turn this around
#this could run slightly faster, especially for very, very large arrays
"xyx" -in $n
"xyz" -notin $n

cls

#a practical example
$list = "rdpclip","searchapp","spoolsv"

#this is not the only way to do this task
Get-Process | Where-Object {$list -contains $_.name}

$allowed = "default share","Remote Admin","Remote IPC"
#this is not the only way to do this task
#but it helps demonstrate the -notin operator
Get-SmbShare -CimSession prospero | Where-Object {$_.Description -notin $allowed}

cls
