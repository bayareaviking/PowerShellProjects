class Employee
{
    [string]$employeeId
    [string]$firstName
    [string]$lastName
    [DateTime]$hireDate
    [string]$department 

    # Constructors
    Employee ()
    {
        # Default
    }
    Employee ([string]$ID, [string]$First, [string]$Last, [DateTime]$HD, [string]$Dep)
    {   
        $this.employeeId = $ID
        $this.firstName = $First
        $this.lastName = $Last
        $this.hireDate = $HD
        $this.department = $Dep
    }
}
class Employees {
    [object[]]$employees

    # Functions
    [object[]] Import([string]$FilePath) 
    {

        # Discovering the file extension and importing
        $extension = $($FilePath | Split-Path -Leaf).Split(".")[1]    
        switch ($extension) {
            "txt" {
                $this.employees = Get-Content -Path $FilePath
                break;
            }
            "json" {
                $this.employees = Get-Content -Path $FilePath | ConvertFrom-Json
                break;
            }
            "csv" {
                $this.employees = Import-Csv -Path $FilePath 
                break;
            }
            default {
                Write-Warning -Message "That file type is not supported.\nSupported types: txt, csv, json"
                break;
            } 
        } #>
        return $this.employees
    }

    [object[]] Add([Employee]$New) 
    {   
        $this.employees += $New
        return $this.employees
    }

    [void] List()
    {
        $this.employees
    }
}

$employees = New-Object -TypeName Employees
$employees.Import("C:\Temp\employees.json")
Start-Sleep 2
$employees

Start-Sleep 2

$new = New-Object -TypeName Employee
$new.employeeId = "1007"
$new.firstName = "Clint"
$new.lastName = "Barton"
$new.hireDate = $((Get-Date).Date)
$new.department = "Security"

$employees.Add($new)



