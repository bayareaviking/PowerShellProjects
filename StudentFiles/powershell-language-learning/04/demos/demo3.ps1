Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#demo splitting and joining arrays

#split into arrays
$k = "Roy Biv"
$k.split()

$s = "This.Is.A.String"
$s.split(".")

$m = "PowerShell 7 is Awesome Sauce"
$m.split(" ", 3)

cls

#or you can get more complicated with the -Split operator
#can use regular expression patterns
#If you have advanced regex experience you could also use
#named captures and not worry about splitting
$r = "Data foo bar 44 Field1 88 Field2 435 Field3"

#split on at least 2 digits
#this almost works
$d = $r -split "\s\d{2,}\s"
$d.Count
$d

$d[0]
#This could also be treated as an array
$d[0].split()

help about_split

cls

#joining arrays
$arr =2,4,6,8
$arr
-join $arr

$arr -join " "
$arr -join "-"

cls