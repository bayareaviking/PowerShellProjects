# see https://docs.microsoft.com/powershell/scripting/dsc/resources/authoringresourceclass?view=powershell-5.1

enum State {
    Installed
    NotPresent
}

[DSCResource()]
class CompanyRSATClass {

    #region properties
    # A DSC resource must define at least one key property
    [DscProperty(Key)]
    [string]$Name

    [DscProperty()]
    [state]$State

    [DscProperty(NotConfigurable)]
    [string]$DisplayName
    <#
    you can also have other mandatory properties
    [DscProperty(Mandatory)]
    [string]$Foo
    #>
    #endregion

    #region methods

    [CompanyRSATClass] Get() {
        Write-Verbose "Getting current state of $($this.name)"
        #call the helper function
        $result = GetRSAT -name $this.name $this.state

        #methods must use RETURN keyword for output
        return $result
    } #get

    [Bool] Test() {
        Write-Verbose "Testing $($this.name) to be $($this.State)"
        $test = TestRSAT -name $this.Name -state $this.state
        Return $test

    } #Test

    [void] Set() {
        Write-Verbose "Setting RSAT Feature $($this.name) to be $($this.State)"
        #this should be moved to a helper function
        Try {
            $item = Get-WindowsCapability -Online -Name $this.Name -ErrorAction Stop
            Write-Verbose "Current state is $($item.State.toString())"
            if (($item.state.toString() -eq "NotPresent") -AND ($This.state -eq [state]::Installed)) {
                Write-Verbose "Adding $($this.Name)"
                Add-WindowsCapability -Online -Name $this.name -ErrorAction Stop
            }
            elseif (($item.state.ToString() -eq "Installed") -AND ($This.state -eq [state]::NotPresent)) {
                Write-Verbose "Removing $($this.Name)"
                Remove-WindowsCapability -Online -Name $this.name -ErrorAction Stop
            }
        }
        Catch {
            Throw $_
        }

    } #set
    #endregion

} #close class

#using helper functions which are easier to Pester test
Function GetRSAT {
    [cmdletbinding()]
    Param([string]$Name, [state]$State)

    Try {
        $item = Get-WindowsCapability -Online -Name $Name -ErrorAction Stop
        #the output will be used by the Get() method in the class

        $result = @{
            Name        = $item.Name
            DisplayName = $item.Displayname
            State       = $Item.State.toString()
        }
    }
    Catch {
        Throw $_
    }
    $result
}

Function TestRSAT {
    [cmdletbinding()]
    Param([string]$Name, [state]$State)

    Try {

        $package = Get-WindowsCapability -Online -Name $Name -ErrorAction Stop
        Write-Verbose "Found package $($package.name) [$($package.state)]"

        #the State property needs to be treated as a string
        $package.state.tostring() -eq $this.State

    }
    Catch {
        Throw $_
    }
}


<#
Copy module to C:\Program Files\WindowsPowerShell\Modules

Get-DSCResource CompanyRSATClass
Get-DSCResource CompanyRSATClass -syntax

Test with Invoke-DSCResource

$test = @{
    State = "Installed"
    Name = "Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0"
}

Invoke-DscResource -method get -Property $test -name CompanyRSATClass -ModuleName companyrsatclass -Verbose
Invoke-DscResource -method test -Property $test -name CompanyRSATClass -ModuleName companyrsatclass -Verbose
Invoke-DscResource -method set -Property $test -name CompanyRSATClass -ModuleName companyrsatclass -Verbose
#>