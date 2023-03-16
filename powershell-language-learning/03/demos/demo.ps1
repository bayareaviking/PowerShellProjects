Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#these operators have existed in PowerShell almost from the beginning

#start with help
help about_*operator*

cls

#Use common comparison operators
#comparison results are always a boolean
5 -gt 2
2 -ge 2
5 -lt 2
2 -le 5

$i = 7
$i -eq 7
$i -ne 7

#case-insensitive
"jeff" -eq "JEFF"

#but you can make it case-sensitive
#you can also use regular expressions which are
#not covered in this course
"jeff" -ceq "JEFF"

cls

#Use -like and -match
#like uses wildcards
"foo" -like "f*"
#not case-sensitive
"bar" -notlike "B*"
#but they can be
"bar" -clike "B*"

#match uses regular expressions
help about_Regular_Expressions

"abc-1234" -match "\d+"
"1234" -notmatch "\d+"
Get-Process | Where-Object company -Match 'logitech' | Select-Object ID, Name, company
Get-Process | Where-Object company -NotMatch 'micro' | Group-Object Company

Get-Process | Where-Object company -Match "Firefox|Mozilla"

cls

#Use common math operators
5 + 8
9 / 3
2 * 3 * 4
10 - 6

#control precedence
(((5 + 3) / 2) * 7) - 1
#It matters
5 + 3 / 2 * 7 - 1

cls

#Use the range operator
1..5
10..1
#this is technically two ranges
(1..4), (7..10)

#doesn't work with letters, but you could use [CHAR]
97..100 | ForEach-Object { [Char]$_ }
cls


#Test an expression with -AND and -OR
# you will most likely use this when you get to scripting

# All expressions must be True. Parentheses are recommended

$i = 4
($i -le 10) -AND ($PSVersionTable.PSVersion.Major -ge 7)

$i = 20
($i -le 10) -AND ($PSVersionTable.PSVersion.Major -ge 7)

#OR at least one must be true
($i -le 10) -OR ($PSVersionTable.PSVersion.Major -ge 7)

#you can combine
$name = "jeff"
($i -ge 20) -AND (($name -eq "Jeff") -OR $IsLinux)

cls

# -Not

#reverse
Test-Path c:\windows\notepad.exe
-Not (Test-Path c:\windows\notepad.exe)
#or use !
! (Test-Path c:\windows\notepad.exe)

#typically used in IF statements
if (-not (Test-Connection FOO -Quiet)) { "offline" }

cls