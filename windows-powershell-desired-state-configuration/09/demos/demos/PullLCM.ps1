[DSCLocalConfigurationManager()]
configuration PullLCM {
    
    Param([string]$Computername, [string]$ID)
    
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
            AllowUnsecureConnection = $true
        }

        ResourceRepositoryWeb SRV2 {
            ServerURL               = 'http://SRV2:8080/PSDSCPullServer.svc'
            AllowUnsecureConnection = $true
        }

    }
}
