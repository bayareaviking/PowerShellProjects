Configuration DebugDemo {

 Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
 Node SRV1 {

    Service Bits {
        Name = "bits"
        State = 'Running'
        StartupType = 'Automatic'
    }

 }
}

#the output path must already exist
# DebugDemo -OutputPath C:\DSCConfigs\DebugDemo