
Configuration FeaturesConfiguration {

    Param([string[]]$Computername)

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration' -ModuleVersion 1.1

    Node $Computername {

        WindowsFeature InternalDB {
            Name                 = 'Windows-Internal-Database'
            Ensure               = 'Present'
            IncludeAllSubFeature = $True
        }

        WindowsFeature Backup {
            Name   = 'Windows-Server-Backup'
            Ensure = 'Present'
        }

        WindowsFeature PowerShellv2 {
            Name   = 'PowerShell-v2'
            Ensure = 'Absent'
        }

        WindowsFeature SNMP {
            Name                 = 'SNMP-Service'
            Ensure               = 'Present'
            IncludeAllSubFeature = $True
        }
    } #node

} #config

