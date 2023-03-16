Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#demo common number techniques

1kb
3kb

1mb
1gb
1tb

459870234/1mb

#you can round to an integer
54598225634/1gb -as [Int32]

cls

#doing math with .NET

#this is just a way to show you the method names
[math].GetMethods() | Group-Object -Property Name

#disover how to use it
# is the static method operator
[math]::pow.OverloadDefinitions
[math]::pow(2,3)

[math]::sqrt(144)

#this is one you'll use often
[math]::round.OverloadDefinitions
$i = 345.6789
#round to 2 decimal points
[math]::round($i,2)

$m = Get-ChildItem c:\scripts\*.ps* | Measure-Object -property Length -sum
$m.Sum
#in KB
$m.sum/1kb
#in MB
$m.sum/1mb
#as an int
$m.sum/1kb -as [int]
#rounded
[math]::round($m.sum/1mb,4)

cls

#a hashtable of parameters to splat to Get-ChildItem
$get = @{
 Path = "c:\scripts"
 File = $True
 Recurse =$True
 exclude = "*.exe","*.dll","*.appx "
}

Get-ChildItem @get |
Where-Object {$_.Extension} |
Group-Object -Property Extension -AsHashTable | Tee-Object -Variable g
$g

#this is code that would make a good PowerShell script or function
$g.GetEnumerator() | Select-Object -Property @{Name="FileType";Expression={$_.Name}},
@{Name="Count";Expression = {$_.value.count}},
@{Name="SizeKB";Expression = {
 $m = $_.value | Measure-Object -Property length -sum
 [math]::round($m.sum/1KB,2)
}} | Sort-Object -Property SizeKB -Descending |
Select-Object -first 10

cls

#another practical example
Get-CimInstance Win32_OperatingSystem -OutVariable os |
Select-Object Caption,TotalVisibleMemorySize,FreePhysicalMemory

#don't assume all values are in bytes
$os | Select-Object Caption,
@{Name="TotalMemGB";Expression = {($_.TotalVisibleMemorySize/1mb) -as [int]}},
@{Name= "FreeMemGB";Expression = {[math]::round($_.FreePhysicalMemory/1mb,2)}}

cls