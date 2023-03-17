# Using PowerShell Variables

Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

# Getting Variables
#use a command
Get-Variable

#get variables by name with the $ prefix
#these are built-in variables
$PSVersionTable
$pwd
$HOME

#this will fail
Get-Variable $home

#use the variable name when using the cmdlet
Get-Variable home

#the variable has properties
Get-Variable isWindows | Select-Object *

#but you work with the value
$pid
$pid | Get-Member

Get-Process -Id $pid

help about_Variables
Clear-Host

# Creating Variables
#variable names should be meaningful

$a = 2
$a

$n = "foo"

#this command is part of the PSTeachingTools module
# Install-Module PSTeachingTools -force
$veg = Get-Vegetable c*
$veg

#this is technically possible, or if you need something special
New-Variable -Name ver -Value 1
$ver
New-Variable -Name user -Value "Jeff" -Option ReadOnly
New-Variable -Name pi -Value 3.14 -Option Constant
$user
$pi

#change
$n = "bar"
$n

$ver = 2
$ver

#this will fail
$user = "Gladys"
#you could use this command
Set-Variable -Name user -Value Gladys -Force -PassThru

#but not constants
Set-Variable pi -Value 1 -Force
#constants can't be removed or recreated

#you can clear variable values
Clear-Variable user -Force
Get-Variable user

# other ways of working with variables
Remove-Variable veg
Get-Variable veg
#but it didn't change the source
Get-Vegetable c*

Clear-Host

