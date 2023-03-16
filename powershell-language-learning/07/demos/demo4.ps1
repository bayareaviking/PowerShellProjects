Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#format operator
#these links may change
# https://docs.microsoft.com/dotnet/standard/base-types/composite-formatting

$s = Get-S ervice bits
"{0} is {1}" -f $s.name,$s.status

# https://docs.microsoft.com/dotnet/standard/base-types/standard-numeric-format-strings

#results are strings
#fixed format
"{0:f}" -f 1234.567643
"{0:f0}" -f 1234.56764
"{0:f3}" -f 1234.56764

#numeric
"{0:n3}" -f 1234.56764

#percent
"{0:p}" -f (45/100)
"{0:p4}" -f (455/1237)

#currency is culture specific
"{0:c}" -f 23.56

cls

#date time formats are similar to what we looked at earlier
# https://docs.microsoft.com/dotnet/standard/base-types/standard-date-and-time-format-strings

[datetime]$d = "12/31/2022 5:10AM"
#case sensitive
"{0:d}" -f $d
"{0:D}" -f $d
"{0:g}" -f $d
"{0:f}" -f $d
"{0:u}" -f $d
"{0:yyyy-dd-MM}" -f $d

cls

