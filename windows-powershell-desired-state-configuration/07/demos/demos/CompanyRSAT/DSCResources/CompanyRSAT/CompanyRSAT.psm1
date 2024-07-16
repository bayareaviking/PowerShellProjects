#Traditional DSC Custom Resource

# see https://docs.microsoft.com/powershell/scripting/dsc/resources/authoringresourcemof?view=powershell-5.1

Enum State {
    Installed
    NotPresent
}
Function Get-TargetResource {
    [cmdletbinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    Try {
        $item = Get-WindowsCapability -Online -Name $Name -ErrorAction Stop
        $state = $item.State
    }
    Catch {
        $state = "Unknown"
    }

    #return a hashtable
    # Name is required
    # Displayname is an optional element in the Schema MOF
    @{
        Name        = $item.Name
        DisplayName = $item.DisplayName
        State       = $state
    }
}

#Set will only be called if Test-TargetResource returns false

<#
some features can't be uninstalled due to dependencies
 https://docs.microsoft.com/windows-hardware/manufacture/desktop/features-on-demand-non-language-fod#fods-that-are-not-preinstalled
 or they can't be removed using PowerShell
#>

Function Set-TargetResource {
    [cmdletbinding()]
    [OutputType("None")]
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [state]$State
    )

    Write-Verbose "Setting RSAT Feature $name to be $State"
    Try {
        $item = Get-WindowsCapability -Online -Name $Name -ErrorAction Stop
        if ($state -eq 'Installed') {
            Write-Verbose "Adding $Name"
            Add-WindowsCapability -Online -Name $name -ErrorAction Stop
        }
        else {
            Write-Verbose "Removing $Name"
            Remove-WindowsCapability -Online -Name $name -ErrorAction Stop
        }
    }
    Catch {
        Throw $_
    }

}

Function Test-TargetResource {
    [cmdletbinding()]
    [OutputType([Boolean])]
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [state]$State
    )

    Try {
        Write-Verbose "Testing $name to be $State"
        $package = Get-WindowsCapability -Online -Name $Name -ErrorAction Stop
        Write-Verbose "Found package $($package.name) [$($package.state)]"

        $package.state -eq $State.ToString()

    }
    Catch {
        Throw $_
    }

}

#view MOF

<#

Copy module to C:\Program Files\WindowsPowerShell\Modules
.\copy-mofmodule.ps1

Get-DSCResource RSAT
Get-DSCResource RSAT -syntax

Test with Invoke-DSCResource

$test = @{
    State = "NotPresent"
    Name = "Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0"
}

Invoke-DscResource -method test -Property $test -name RSAT -ModuleName companyrsat -Verbose
Invoke-DscResource -method get -Property $test -name RSAT -ModuleName companyrsat -Verbose
Invoke-DscResource -method set -Property $test -name RSAT -ModuleName companyrsat -Verbose

#>