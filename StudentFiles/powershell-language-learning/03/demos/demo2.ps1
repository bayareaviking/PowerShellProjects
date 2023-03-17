#operators introduced in PowerShell 7

Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#Use the chain operators
help about_Pipeline_Chain_Operators

#easier than using IF statements

#first command succeeed or fail {operator} second command
Get-Process -Id $pid && 100
Get-Process -Id 99999 && 100

#if first fails then do the second
Get-Process -Id 99999 || 100

$computer = $env:computername
Test-WSMan $computer && Get-CimInstance win32_bios -ComputerName $computer
#or supress the first part
Test-WSMan $computer | Out-Null && Get-CimInstance win32_bios -ComputerName $computer

#combine
$computer = "foo"
(Test-WSMan $computer | Out-Null && Get-CimInstance win32_bios -ComputerName $computer) || Write-Warning "Failed on $Computer"

cls

#Use the ternary operator
#alternative to an If statement you'll most likely use in scripts
help about_if
If (2 -ge 1) { "yes" } else { "no" }
# conditional test ? True Action : False Action
2 -ge 1 ? "yes" : "no"

notepad.exe
#wrap expressions in ()
(Get-Process notepad) ? (Stop-Process -Name Notepad) : (Write-Warning "Notepad is not running")
#another example
$isWindows ? (Get-CimInstance win32_operatingsystem) : (lsb_release -d)

cls

#Use the Null-Coalescing operators
<#
The null-coalescing operator ?? returns the value of its left-hand operand
if it isn't null. Otherwise, it evaluates the right-hand operand and
returns its result. The ?? operator doesn't evaluate its right-hand operand
if the left-hand operand evaluates to non-null.
#>

$n = $null
$n ?? (Write-Warning "the variable is null")

$v = $PSEdition ?? ("unknown")
$v

<#
Null-coalescing assignment operator ??=

The null-coalescing assignment operator ??= assigns the value of its
right-hand operand to its left-hand operand only if the left-hand operand
evaluates to null. The ??= operator doesn't evaluate its right-hand operand
if the left-hand operand evaluates to non-null.
#>

$n ??= "foo"
$n
$n ??= "bar"
$n

$p = Get-Process | Where-Object { $_.WorkingSet -gt 1GB }
$p ??= 0
$p

<#
Null-conditional operators ?.
A null-conditional operator applies a member access, ?.,
or element access, ?[], operation to its operand only if that operand
evaluates to non-null; otherwise, it returns null.
#>

#test if you are trying access a null object member
$p = Get-Process -Id $pid
$p.ToString()

#but what if $p didn't get created as expected?
$p = $null
$p.ToString()
#need to use {} because ? is technically legal for a variable name.
${p}?.ToString()

$var = ${p}?.ToString() ?? "method failed"
$var

cls

#there are other ways to use PowerShell to get the same results with
#the null-related operators.