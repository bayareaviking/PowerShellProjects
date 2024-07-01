using module .\Modules\TestModule.psm1

$emp1 = New-Object -TypeName "Employee"
$emp1.FirstName = "Billy"
$emp1.LastName = "Buttfuck"
$emp1.Department = "Sales"
$emp1.Title = "Bro"
[Employee]$emp2 = [Employee]::new("Bahb", "Fawget", "Information Technology", "Gopher")

<# $const = [ordered]@{
    FirstName = "Sally";
    LastName = "Deepthroat";
    Department = "HR";
    Title = "Fluffer"
} #>

$const = [System.Collections.Generic.Dictionary[String, String]]::new()
$const.Add("Firstname", "Sally")
$const.Add("LastName", "Deepthroat")
$const.Add("Department", "HR")
$const.Add("Title", "Fluffer")

$emp3 = New-Object -TypeName "Employee" -Property $const

$emp1.GetType()
$emp2.GetType()
$emp3.GetType()
Write-Output ""
$emp1.PrintEmployeeInfo()
$emp2.PrintEmployeeInfo()
$emp3.PrintEmployeeInfo()