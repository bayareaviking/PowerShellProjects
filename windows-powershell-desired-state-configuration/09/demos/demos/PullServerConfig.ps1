Configuration HTTPPullServer {

    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -moduleName xPSDesiredStateConfiguration -ModuleVersion 9.1.0
    Import-DSCResource -ModuleName NetworkingDSC -ModuleVersion 8.2.0

    # Dynamically find the applicable nodes from configuration data
    Node $AllNodes.where{ $_.Role -eq 'Web' }.NodeName {

        <#
        I am using a more granular approach instead of simply installing the IIS feature

            WindowsFeature IIS {
                Ensure = "Present"
                Name = "Web-Server"
            }
        #>

        WindowsFeature DefaultDoc {
            Ensure = "Present"
            Name   = "Web-Default-Doc"
        }
        WindowsFeature HTTPErrors {
            Ensure = "Present"
            Name   = "Web-HTTP-Errors"
        }
        WindowsFeature HTTPLogging {
            Ensure = "Present"
            Name   = "Web-HTTP-Logging"
        }
        WindowsFeature StaticContent {
            Ensure = "Present"
            Name   = "Web-Static-Content"
        }
        WindowsFeature RequestFiltering {
            Ensure = "Present"
            Name   = "Web-Filtering"
        }

        #Install additional IIS components to support the Web Application

        WindowsFeature NetExtens4 {
            Ensure = "Present"
            Name   = "Web-Net-Ext45"
        }
        WindowsFeature AspNet45 {
            Ensure = "Present"
            Name   = "Web-Asp-Net45"
        }
        WindowsFeature ISAPIExt {
            Ensure = "Present"
            Name   = "Web-ISAPI-Ext"
        }
        WindowsFeature ISAPIFilter {
            Ensure = "Present"
            Name   = "Web-ISAPI-filter"
        }
        WindowsFeature DirectoryBrowsing {
            Ensure = "Present"
            Name   = "Web-Dir-Browsing"
        }
        WindowsFeature StaticCompression {
            Ensure = "Present"
            Name   = "Web-Stat-Compression"
        }

        # I don't want these Additional settings for Web-Server to ever be enabled:
        # This list is shortened for demo purposes. I include eveything that should not be installed

        WindowsFeature ASP {
            Ensure = "Absent"
            Name   = "Web-ASP"
        }
        WindowsFeature CGI {
            Ensure = "Absent"
            Name   = "Web-CGI"
        }
        WindowsFeature IPDomainRestrictions {
            Ensure = "Absent"
            Name   = "Web-IP-Security"
        }

        # !!!!! # GUI Remote Management of IIS requires the following: - people always forget this until too late

        WindowsFeature Management {
            Name   = 'Web-Mgmt-Service'
            Ensure = 'Present'
        }
        Registry RemoteManagement {
            Key       = 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server'
            ValueName = 'EnableRemoteManagement'
            ValueType = 'Dword'
            ValueData = '1'
            DependsOn = @('[WindowsFeature]Management')
        }
        Service StartWMSVC {
            Name        = 'WMSVC'
            StartupType = 'Automatic'
            State       = 'Running'
            DependsOn   = '[Registry]RemoteManagement'
        }

    } #End Node Role Web


    Node $AllNodes.where{ $_.Role -eq 'PullServer' }.NodeName {


        WindowsFeature DSCServiceFeature {
            Ensure = "Present"
            Name   = "DSC-Service"
        }

        # I am NOT using HTTPS to keep the demo a little simpler
        # The best practice is to use HTTPS
        xDscWebService PSDSCPullServer {
            Ensure                   = "Present"
            EndpointName             = $Node.PullServerEndPointName
            Port                     = $Node.PullServerPort
            PhysicalPath             = $Node.PullserverPhysicalPath
            CertificateThumbPrint    = $Node.PullServerThumbprint
            ModulePath               = $Node.PullServerModulePath
            ConfigurationPath        = $Node.PullserverConfigurationPath
            ConfigureFirewall        = $False
            State                    = "Started"
            UseSecurityBestPractices = $False #can't use best practices unless using a certificate and HTTPS
            DependsOn                = "[WindowsFeature]DSCServiceFeature"
        }
        #defining my own firewall rule
        Firewall PSDSCPullServerRule {
            Ensure      = 'Present'
            Name        = "DSC_PullServer_$($Node.PullServerPort)"
            DisplayName = "DSC_PullServer_$($Node.PullServerPort)"
            Group       = 'DSC PullServer'
            Enabled     = $true
            Action      = 'Allow'
            Direction   = 'InBound'
            LocalPort   = $Node.PullServerPort
            Protocol    = 'TCP'
            DependsOn   = '[xDscWebService]PSDSCPullServer'
        }

    } # End Node PullServer

} # End Config

