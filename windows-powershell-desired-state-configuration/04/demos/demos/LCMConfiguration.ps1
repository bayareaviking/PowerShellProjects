[DscLocalConfigurationManager()]
Configuration LCMConfig {
    Node SRV1 {
        Settings {
            RebootNodeIfNeeded = $True
            ConfigurationMode  = "ApplyAndAutoCorrect"
            ActionAfterReboot  = "ContinueConfiguration"
            RefreshMode        = "Push"
        }
    }
}