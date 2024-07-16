#demo MOF-based custom resource
#run in the scripting editor
Return "This is a walk-through demo script file"

Clear-Host

#region view the module files
#Get-ChildItem .\CompanyRSAT -Recurse
Get-Childitem C:\m7\demos\CompanyRSAT -recurse
tree /F /A C:\m7\demos\CompanyRSAT

#endregion

#region open the files.

Get-ChildItem .\CompanyRSAT -File -Recurse |
ForEach-Object { psedit $_.fullname }

#view .psm1,.psd1,.mof
# note the use of a friendly name in the MOF compared
# to the "official" name

#endregion

#region DSC Configurations using the custom resource module
psedit .\RsatConfig3.ps1, .\RsatConfigData.psd1

rsatconfig3 -ConfigurationData .\RsatConfigData.psd1 -OutputPath C:\dscConfigs\rsatdemo3
psedit C:\dscconfigs\rsatdemo3\Win10.mof

#endregion

#region deploy the resource

#need to install the custom resource on the remote server
#use whatever process you want
$tmp = New-PSSession -ComputerName Win10
$splat = @{
    Path        = 'C:\Program Files\WindowsPowerShell\Modules\CompanyRSAT'
    Destination = 'C:\Program Files\WindowsPowerShell\Modules\'
    Container   = $True
    Recurse     = $true
    ToSession   = $tmp
    Force       = $True
}
Copy-Item @splat
Invoke-Command { Get-DscResource RSAT } -Session $tmp
Remove-PSSession $tmp

#endregion

#region run the configuration

Start-DscConfiguration -Wait -Force -Verbose -Path C:\dscConfigs\rsatdemo3
Get-DscConfiguration -CimSession Win10

#endregion

