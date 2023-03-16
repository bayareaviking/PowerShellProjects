Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#Contains methods
$j = @{name = "foo" }

#keys must be unique
$j.add("name", "bar")

$j | Get-Member -Name contains*
$j.ContainsKey("name")
$j.contains("name")

cls

#this is the kind of thing you would put in a script

Get-Process |
ForEach-Object -Begin { $p = @{} } -Process {
    if ($p.contains($_.name)) {
        $p.item($_.name) += $_.WS
    }
    else {
        $p.Add($_.name, $_.WS)
    }
}

$p
#this won't work the way you think
$p | Sort-Object -Property name

$p | Get-Member
#You need to enumerate the hashtable with GetEnumerator()
$p.GetEnumerator() | Get-Member
#Name is an alias property for Key
$p.GetEnumerator() | Sort-Object -Property Name
$p.GetEnumerator() | Where-Object { $_.value -ge 250MB }

cls



