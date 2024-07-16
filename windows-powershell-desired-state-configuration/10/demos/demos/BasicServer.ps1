Configuration BasicCompanyServer {

    param([string[]]$Computername)

    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName ComputerManagementDSC -ModuleVersion 8.5.0
    Import-DscResource -ModuleName NetworkingDSC -ModuleVersion 8.2.0

    Node $Computername {
        File Reports {
            DestinationPath = "C:\Reports"
            Ensure          = "Present"
            Type            = "Directory"
        }

        WindowsFeature NoPS2 {
            Ensure = "Absent"
            Name   = "PowerShell-V2"
        }

        WindowsFeature Backup {
            Name                 = "Windows-Server-Backup"
            Ensure               = "Present"
            IncludeAllSubFeature = $True
        }

        SMBShare Reports {
            Name        = "Reports"
            Description = "Company Reports share"
            ensure      = "Present"
            Path        = "C:\Reports"
            FullAccess  = "company\domain admins"
            DependsOn   = "[File]Reports"
        }

        HostsFile Hosts {
            Hostname  = "SRV3.company.pri"
            IPAddress = "192.168.3.60"
            Ensure    = "Present"
        }

        WindowsEventLog Security {
            LogName            = "Security"
            IsEnabled          = $True
            MaximumSizeInBytes = 4GB
        }

        Service RemoteRegistry {
            Name        = "RemoteRegistry"
            State       = "Stopped"
            StartupType = "Disabled"
        }
    } #node
} #end BasicCompanyServer configuration

