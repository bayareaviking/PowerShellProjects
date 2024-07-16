[DSCLocalConfigurationManager()]
Configuration NamedConfigLCM {
    param
    (
        [Parameter(Mandatory)]
        [string[]]$ComputerName,

        [Parameter(Mandatory)]
        [string]$RegistrationKey
    )
    Node $ComputerName {

        Settings {
            RebootNodeIfNeeded   = $True
            ActionAfterReboot    = 'ContinueConfiguration'
            AllowModuleOverwrite = $True
            ConfigurationMode    = 'ApplyAndAutoCorrect'
            RefreshMode          = 'Pull'
            RefreshFrequencyMins = 30
            ConfigurationID      = "" # Setting to blank - but can leave a guid in - won't matter
        }

        #I am not using HTTPS for my demo
        ConfigurationRepositoryWeb SRV2 {
            ServerURL               = 'http://SRV2:8080/PSDSCPullServer.svc'
            CertificateID           = ""
            AllowUnsecureConnection = $True
            RegistrationKey         = "$RegistrationKey"
            ConfigurationNames      = @("BasicCompanyServer") #The name of your configuration
        }
    }
}
