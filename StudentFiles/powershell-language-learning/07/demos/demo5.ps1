Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

# putting it all together

$os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName Prospero
#Turn into bytes
$InUse = ($os.TotalVisibleMemorySize - $os.FreePhysicalMemory)*1KB
#total bytes in use
$inUse

#define a hashtable of parameters to splat
#substitute your own computername

$cim = @{
ClassName = "win32_process"
ComputerName = "Prospero"
filter = "WorkingSetSize >=$(250MB)"
}

Get-CimInstance @cim | Select-Object -property ProcessID,Name,
@{Name="WorkingMB";Expression = {[math]::Round($_.WorkingSetSize/1mb,2)}},
@{Name="PctMemory";Expression = {"{0:p2}" -f ($_.WorkingsetSize/$Inuse)}}


# Install-Module Microsoft.PowerShell.ConsoleGuiTools -force

$n = Get-Content c:\work\computers2.txt |
Where-Object {($_.length -gt 0) -AND (Test-WSMan $_.trim())}

$n

Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $n.trim() |
Select-Object -property @{Name="Computername";Expression={$_.CSName}},
@{Name="OS";Expression = {$_.Caption.Replace("Microsoft","").Trim()}},Version,
@{Name="Uptime";Expression={New-Timespan -Start $_.LastBootUpTime -end (Get-Date)}},
@{Name="Installed";Expression = {"{0:MMMyyyy}" -f $_.InstallDate}},
@{Name="InstallAge";Expression = {(Get-Date) - $_.InstallDate}},
@{Name="TotalMemGB";Expression = {$_.TotalVisibleMemorySize/1MB -as [int]}} |
Out-ConsoleGridView

cls

$cred = Get-Credential jeff
$computer = "prospero"

$data = Get-WinEvent system -ComputerName $computer -Credential $cred -OutVariable all |
Group-Object providername -NoElement |
Where-Object {$_.count -ge 250}

$data

$data | foreach-object {
 [pscustomobject]@{
   Source = $_.Name.ToLower()
   Count = $_.Count
   PctTotal = "{0:p2}" -f ($_.count/$all.count)
   Computername = $computer.toUpper()
   Report = (Get-Date -Format d)
 }
} | Sort-Object -Property count -Descending | Format-Table


cls

#All of these examples are things you could turn into scripts and functions
#But you need to make sure you can run it first at the console

<#
Bonus demo

$env:PSModulePath

#I would normally leave the numeric value as a number
#using -F treats it as a string which requires an extra
#step on my part. Think of this example more of a demonstration
#and not production-ready code.

$env:PSModulePath -split ";" | foreach-object {
 $m = Get-Childitem -path $_ -file -Recurse |
 Measure-Object -Property length -sum
 [pscustomobject]@{
 Path = $_
 Files = $m.count
 SizeKB = "{0:n0}" -f ($m.sum/1KB -as [int32])
 }
} | Sort-Object {$_.sizekb -as [int32]} -Descending

cls
#>