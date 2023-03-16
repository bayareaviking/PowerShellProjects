Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#demo working with hashtables

#splatting
#standard usage
Get-Service -Name b* -Exclude bits

#define a hashtable of parameters and values
$p = @{Name = "b*"; Exclude = "bits" }
#splat the hashtable
Get-Service @p

$cim = @{Classname = "Win32_bios"; Verbose = $True }
$cim
Get-CimInstance @cim
$cim.Classname = "Win32_operatingsystem"
Get-CimInstance @cim

#you can combine splatting with other parameters
Get-CimInstance @cim -ComputerName prospero
#this is very handy when it comes to scripting

help about_Splatting

cls

