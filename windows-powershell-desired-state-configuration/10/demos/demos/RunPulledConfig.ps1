#requires -version 5.1
Param(
 [Parameter(Mandatory)]
 [string]$Computername,
 [string]$PullServer = "SRV2"
 )

Clear-Host
#create the configuration

Configuration PulledConfig2 {

    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DSCResource -ModuleName ComputerManagementDSC -ModuleVersion 8.5.0
    Import-DscResource -ModuleName NetworkingDSC -ModuleVersion 8.2.0

    #configurations can be generic
    Node Localhost {

        File Reports {
            DestinationPath = "C:\Reports"
            Ensure          = "Present"
            Type            = "Directory"
        }
        File Readme {
            DestinationPath = "C:\Reports\readme.txt"
            Ensure = 'Present'
            Type = 'File'
            Contents = "Company reports share."
            DependsOn = "[File]Reports"
        }
        SMBShare ReportsShare {
            DependsOn  = "[File]Reports"
            Name       = "Reports$"
            Path       = "C:\Reports"
            FullAccess = "Company\Domain Admins"
        }
        HostsFile Hosts {
            Hostname  = "SRV4.company.pri"
            IPAddress = "192.168.3.61"
            Ensure    = "Present"
        }
        WindowsEventLog Security {
            LogName            = "Security"
            IsEnabled          = $True
            MaximumSizeInBytes = 2gb
        }
        #this could also come from configurationdata
        $noFeature = "PowerShell-V2","Telnet-Client"
        foreach ($item in $noFeature) {
            WindowsFeature $($item.Replace("-", "")) {
                Name   = $item
                Ensure = "absent"
            }
        }

        $addFeature = "Windows-Server-Backup","NLB","SNMP-Service"
        foreach ($item in $addFeature) {
            WindowsFeature $($item.Replace("-", "")) {
                Name                 = $item
                Ensure               = "present"
                IncludeAllSubFeature = $true
            }
        }

        $svcs = "winmgmt","winrm","lanmanserver","lanmanworkstation","winDefend","w32time"
        foreach ($service in $svcs) {
            Service $service {
                Name        = $service
                State       = "Running"
                StartupType = "Automatic"
            }
        }
    } #node
}

#rename with a guid
$id = New-Guid
$out = PulledConfig2 -OutputPath C:\DSCConfigs\pulledconfig2 | Rename-Item -NewName "$id.mof" -PassThru
New-DscChecksum -Path $out -Force

#copy to the pullserver
$s = New-PSSession -ComputerName $PullServer
Copy-Item -Path C:\DSCConfigs\PulledConfig2\$id* -Destination 'C:\Program Files\WindowsPowerShell\DscService\Configuration' -ToSession $s
Remove-PSSession $s

#tweak the LCM to add the ID
[DSCLocalConfigurationManager()]
configuration PullLCM {

    Param([string]$Computername, [string]$ID,[string]$Key)

    Node $Computername {

        Settings {
            RefreshMode          = 'Pull'
            #must match the GUID assigned to the configuration
            #this example assumes a single mof. You'll need to keep
            #track of node names and guids
            ConfigurationID      = $ID
            RefreshFrequencyMins = 30
            RebootNodeIfNeeded   = $true
            ConfigurationMode    = "ApplyAndAutoCorrect"
        }

         #pay attention to web protocol!
        #not using SSL in this demo
        ConfigurationRepositoryWeb SRV2 {
            ServerURL               = 'http://SRV2:8080/PSDSCPullServer.svc'
            RegistrationKey         = $key
            AllowUnsecureConnection = $true
        }

        ResourceRepositoryWeb SRV2 {
            ServerURL               = 'http://SRV2:8080/PSDSCPullServer.svc'
            AllowUnsecureConnection = $true
        }

        ReportServerWeb SRV2 {
            ServerURL               = 'http://SRV2:8080/PSDSCPullServer.svc'
            RegistrationKey         = $key
            AllowUnsecureConnection = $true
        }
      
    }
}

PullLCM -id $id -computername $Computername -key (Get-Content C:\DSCConfigs\RegistrationKeys.txt) -OutputPath C:\DSCConfigs\PullLCM
Set-DscLocalConfigurationManager -Path C:\DSCConfigs\PullLCM -ComputerName $Computername -Verbose

#let the LCM configuration converge
Start-Sleep -Seconds 5

#force the configuration
Update-DscConfiguration -Verbose -Wait -ComputerName $Computername
