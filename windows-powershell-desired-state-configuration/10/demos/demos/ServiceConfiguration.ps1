Configuration ServiceConfiguration {
    Param([string[]]$Computername)

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration' -ModuleVersion 1.1
    Node $Computername {

        Service RemoteRegistry {
            Name        = 'RemoteRegistry'
            State       = 'Running'
            StartupType = 'Automatic'
        }
        Service Defender {
            Name        = 'WinDefend'
            State       = 'Running'
            StartupType = 'Automatic'
        }

        Service Bits {
            Name        = 'Bits'
            State       = 'Running'
            StartupType = 'Manual'
        }

        Service Spooler {
            Name        = 'Spooler'
            State       = 'Stopped'
            StartupType = 'Disabled'
        }

        Service SharedAccess {
            Name        = 'SharedAccess'
            State       = 'Stopped'
            StartupType = 'Disabled'
        }

    } #node

}


