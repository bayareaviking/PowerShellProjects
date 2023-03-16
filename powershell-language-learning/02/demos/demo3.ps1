Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

# Variable expansion
# $name = "Jeff"
#"Hello, my name is $name."
#but not this
# 'Hello, my name is $name.'

#simple
$PSEdition
"I am running the $PSEdition edition of PowerShell."

#complex expansion
$svc = Get-Service WinRM
$svc | Select-Object name, status
"The $svc.name service is currently $svc.status"

# How to use SubExpressions
"The $($svc.name) service is currently $($svc.status)"

#don't do this
"The " + $svc.name + " service is currently " + $svc.status

Clear-Host

