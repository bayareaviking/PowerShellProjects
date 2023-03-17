Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#PSDefaultParameterValues
#this is a special hashtable variable
#you might set these in your PowerShell profile script
$PSDefaultParameterValues.add("Get-WinEvent:Logname", "System")
$PSDefaultParameterValues.add("Get-WinEvent:MaxEvents", 10)
$PSDefaultParameterValues

#use the defaults
Get-WinEvent
#use other values
Get-WinEvent application -max 1

#change a value
$PSDefaultParameterValues["Get-WinEvent:Maxevents"] = 5
Get-WinEvent security

#you can disable them
$PSDefaultParameterValues["Disabled"] = $True
Get-WinEvent

#or clear them
$PSDefaultParameterValues.Clear()
$PSDefaultParameterValues

help about_Parameters_Default_Values

cls

# module summary
# PowerShell uses arrays and hashtables everywhere.
# Be sure to read help for more information and practice on your own
# You will use these things often in PowerShell scripting