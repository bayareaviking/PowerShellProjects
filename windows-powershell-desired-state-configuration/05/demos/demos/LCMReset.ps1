[DSCLocalConfigurationManager()]
Configuration LCMReset {

Node SRV1 {
    Settings {
         RebootNodeIfNeeded = $True
            ConfigurationMode  = "ApplyAndMonitor"
            ActionAfterReboot  = "ContinueConfiguration"
            RefreshMode        = "Push"
    }
 }
}