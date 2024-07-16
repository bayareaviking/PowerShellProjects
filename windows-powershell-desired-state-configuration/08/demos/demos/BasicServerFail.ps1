#this configuration will intentionally error

Configuration Sample2 {
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Node SRV1 {
        Service Winrm {
            State = "running"
            Name = "Winrm"
        }
        Service LanManserver {
            State = "running"
            Name = "LanmanServer"
        }
        Service LanmanWorkstation {
            State = "running"
            Name = "Lanmanworkstation"
        }
        WindowsFeature PSV2 {
            Name = "PowerShell-V2"
            Ensure = 'Absent'
        }
        File Work {
            DestinationPath = "E:\Work"
           Ensure = 'Present'
           Type = 'Directory'
        }
    }
}

# Sample2 -OutputPath C:\DSCConfigs\sample2
# Start-DscConfiguration -Wait -Verbose -Path C:\DSCConfigs\sample2 -force
