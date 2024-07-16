#demo class-based custom resource
# run in the scripting editor
Return "This is a walk-through demo script file"

Clear-Host

#region view the module
#Get-ChildItem .\CompanyRSATClass -Recurse
Get-Childitem c:\m7\demos\companyrsatclass -Recurse

psedit .\CompanyRSATClass\CompanyRSATClass.psm1, .\CompanyRSATClass\CompanyRSATClass.psd1

#endregion

#region deploy the resource

#need to install the custom resource on the remote server
#use whatever process you want
$tmp = New-PSSession -ComputerName Win10
$splat = @{
    Path        = 'C:\Program Files\WindowsPowerShell\Modules\CompanyRSATClass'
    Destination = 'C:\Program Files\WindowsPowerShell\Modules\'
    Container   = $True
    Recurse     = $true
    ToSession   = $tmp
    Force       = $True
}
Copy-Item @splat
Invoke-Command { Get-DscResource CompanyRSATClass } -Session $tmp

#endregion

#region Use the custom resource

psedit .\RsatClassConfig.ps1

rsatconfig4 -ConfigurationData .\RsatConfigData.psd1 -OutputPath C:\dscConfigs\rsatdemo4

psedit C:\dscconfigs\rsatdemo4\Win10.mof

#endregion

#region manually remove some RSAT features for the demo

Invoke-Command {
    Remove-WindowsCapability -Online -Name 'Rsat.Dns.Tools~~~~0.0.1.0'
    Remove-WindowsCapability -Online -Name 'Rsat.CertificateServices.Tools~~~~0.0.1.0'
} -Session $tmp

Remove-PSSession $tmp

#endregion

#region push the configuration

Start-DscConfiguration -Wait -Force -Verbose -Path C:\dscConfigs\rsatdemo4

Get-DscConfiguration -CimSession Win10

#endregion