Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#let's do something practical using arrays

#initialize an empty array
$t = @()
#add 3 random numbers between 0 and 10
$t += (Get-Random -Minimum 0 -Maximum 10 -Count 3)
#create an array of characters
$c = "*", "#", "@", "<", "?", "]", "\"
#add 3 random characters to the array
$t += ($c | Get-Random -Count 3)

#a random seed word you could pull from a dictionary list
$w = "BaNanA"
#strings can be treated as arrays
$w[0..2]
$w.ToCharArray()
#add the character array to the array $t
$t += $w.ToCharArray()

#what is in the array now?
$t
#let's randomize the elements in the array
$rando = $t | Get-Random -Count 9
#join the elements of the array
$pass = -join $rando
#here's a complex password
$pass

#you could create a PowerShell function based on these commands

#learn more
help about_Join

cls

#using the Null ?[] operator
$t
$t[0]

#what if the variable was null?
#PowerShell throws an error
$var[0]

#do this in PS 7
${var}?[0]
#now we get Null
${var}?[0] ?? (Write-Warning "Can't find the item in the array.")

#this is something you'll use more in PowerShell scripting

cls

#There is no provision to remove an item from an array.
#You have to recreate it.
$a = 1..10
#rebuild the array where the number is > 6
#use whatever code you need to filter out what you don't want.4
$a = $a | where { $_ -ge 6 }
$a

cls