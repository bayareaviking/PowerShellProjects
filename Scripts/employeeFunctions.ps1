


function Get-MLEmployees {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$FilePath
    )

    $extension = $($FilePath | Split-Path -Leaf).Split(".")[1]
    
    switch($extension) {
        "txt" {
            $employees = Get-Content -Path $FilePath
            break;
        }
        "json" {
            $employees = Get-Content -Path $FilePath | ConvertFrom-Json
            break;
        }
        "csv" {
            $employees = Import-Csv -Path $FilePath 
            break;
        }
        default {
            Write-Warning -Message "That file type is not supported.\nSupported types: txt, csv, json"
            break;
        } 
    } #>
    return $employees
}

$employees = Get-MLEmployees -FilePath "C:\Temp\employees.json"


$hash = [ordered]@{
    employeeId = "1007"
    firstName = "Clint"
    lastName = "Barton"
    hiredate = "12/06/2009"
    department = "Security"
}

$newEntry = New-Object -TypeName psobject -Property $hash

$newEmployees = $employees += $newEntry

$newEmployees



