@{
    AllNodes = @(
        @{
            NodeName = '*'
        },

        # Unique Data for each Role
        # My demo is NOT using HTTPS, your server should.
        @{
            NodeName                    = 'SRV2'
            Role                        = @('Web', 'PullServer')
            PullServerEndPointName      = 'PSDSCPullServer'
            PullserverPort              = 8080
            PullserverPhysicalPath      = "C:\Windows\inetpub\wwwroot\PSDSCPullServer"
            PullserverModulePath        = "C:\Program Files\WindowsPowerShell\DscService\Modules"
            PullServerConfigurationPath = "C:\Program Files\WindowsPowerShell\DscService\Configuration"
            PullServerThumbPrint        = "AllowUnencryptedTraffic"
        }
    )
}