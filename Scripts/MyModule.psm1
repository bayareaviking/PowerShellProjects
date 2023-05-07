# Test Module for Pluralsight Training
# Course: Building Advanced Windows PowerShell 4 Functions and Modules

function Get-Thing {
    [CmdletBinding()]
    param (
        [string]$Identity
    )
    Write-Output "Here's the thing: $Identity"
}
function Add-Thing {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [string]$Identity
    )
    Write-Output "Creating thing: $Identity"
}

function Set-Thing {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [string]$Identity
    )
    Write-Output "Updating thing: $Identity"
}

function Remove-Thing {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [string]$Identity
    )
    helperThing -Identity $Identity
    Write-Output "Deleting thing: $Identity"
}

function helperThing {
    [CmdletBinding()]
    param (
        [string]$Identity
    )
    
}

Export-ModuleMember -Function Get-Thing, `
                              Set-Thing, `
                              Add-Thing, `
                              Remove-Thing