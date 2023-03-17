Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#demo hashtable fundamentals

#create an empty hashtable
#don't confuse this with an array
$ht = @{}

#or one with values
$ht = @{Name = "jeff"; count = 3; "Sample Entry" = "This is something." }
#a hashtable is its own object
$ht | Get-Member
#listing
$ht

#add an element
$ht.Add("Version", "7")
$ht

#change an element
#using the ++ operator
$ht.count++
$ht.count
#assign a new value
$ht.count = 10
$ht.count

#reference elements
$ht.Name
#this is an alternate name.
#useful if the key has spaces

$ht["Version"]
$ht["Sample Entry"]
#or use the key
$ht.item("name")
#list keys
$ht.keys

#list values
$ht.Values

#remove an element
$ht.remove("version")

$ht
#clear completely
$ht.Clear()
$ht

cls

#hashtables can store anything

$ht = @{Name = "jeff"
    count    = 3
    ps       = Get-Process -Id $pid
    services = Get-CimInstance win32_service
    nested   = @{foo = "bar"; vendor = "Pluralsight"; color = "green" }
}


$ht
#use dotted notation
$ht.services[0..4]
$ht.ps
$ht.ps.CommandLine
$ht.nested
$ht.nested.vendor
$ht.nested.color = "red"
$ht.nested

cls

#ordered hashtables
#hashtables are unordered
$ht
$k = [ordered]@{First = 1; Second = "foo"; Third = "Bart" }
$k
#technically a different object
$k | Get-Member

#but use the same
$k.first
$k.first = 10
$k

help about_Hash_Tables

cls