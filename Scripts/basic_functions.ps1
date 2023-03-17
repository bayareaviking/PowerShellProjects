function Get-AValue ()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [int]$One = 0,
        [Parameter(Mandatory = $true, Position = 1)]
        [int]$Two = 0
    )
    BEGIN { }
    PROCESS {
        [int]$Answer = $One * $Two
    }    
    END { 
        return $Answer
    }
}

Get-AValue -One 30 -Two 4

[int[]]$nums = 24,5
$nums | Get-AValue