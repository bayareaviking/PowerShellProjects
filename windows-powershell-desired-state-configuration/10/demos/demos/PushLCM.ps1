[DSCLocalConfigurationManager()]
configuration PushLCM {

    Param([string[]]$Computername,[string]$key)

    Node $Computername {

        Settings {
            RefreshMode          = 'Push'
            RefreshFrequencyMins = 30
            RebootNodeIfNeeded   = $true
            ConfigurationMode    = "ApplyAndAutoCorrect"
        }

        ResourceRepositoryWeb SRV2 {
            ServerURL               = 'http://SRV2:8080/PSDSCPullServer.svc'
            AllowUnsecureConnection = $true
            RegistrationKey = $key
        }

        ReportServerWeb SRV2 {
            ServerURL               = 'http://SRV2:8080/PSDSCPullServer.svc'
            AllowUnsecureConnection = $true
            RegistrationKey = $key
        }
    }
}

<#
$key = Get-Content C:\DSCConfigs\RegistrationKeys.txt
pushlcm -computername win10,DOM1 -key $key -OutputPath C:\DSCConfigs\pushlcm 
Set-DscLocalConfigurationManager -Path C:\DSCConfigs\pushlcm -Verbose
#>