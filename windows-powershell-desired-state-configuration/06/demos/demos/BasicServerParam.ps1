Configuration BasicServerConfig {

    Param([string[]]$Computername,[switch]$CreateReports)

    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName ComputerManagementDSC -ModuleVersion 8.5.0
    Import-DscResource -ModuleName NetworkingDSC -ModuleVersion 8.2.0

    #the node name can be multiple computernames
    Node $Computername {

        if ($CreateReports) {
            File Reports {
                DestinationPath = "C:\Reports"
                Ensure          = "Present"
                Type            = "Directory"
            }

            File Readme {
                DestinationPath = "C:\Reports\readme.txt"
                Ensure          = "Present"
                Type            = "File"
                Contents        = "This is the company reports file"
                Force           = $True
                DependsOn       = "[File]Reports"
            }
        } #if create reports

        #create a configuration based on external data. This is one way.
        #you would need to run this configuration in the same folder as the CSV file
        # psedit .\features.csv

        $features = Import-Csv .\features.csv
        
        ForEach ($item in $Features) {

            #remove the dashes from the feature name
            WindowsFeature ($item.Feature).Replace("-", "") {
                Ensure               = $item.ensure
                Name                 = $item.Feature
                #convert the value to a boolean
                IncludeAllSubFeature = ([int]$item.Includeall) -as [bool]
            }
        }

        HostsFile Hosts {
            Hostname  = "SRV3.company.pri"
            IPAddress = "192.168.3.60"
            Ensure    = "Present"
        }

        LocalConfigurationManager {
            RebootNodeIfNeeded = $True
            ConfigurationMode  = "ApplyAndAutoCorrect"
            ActionAfterReboot  = "ContinueConfiguration"
            RefreshMode        = "Push"
        }
    } #node


} #end BasicServerConfig

<#
#building demo configurations which I won't be deploying

BasicServerConfig -computername S1,S2 -outputpath c:\DscConfigs\BasicServer
BasicServerConfig -computername S3 -createreports -outputpath c:\DscConfigs\BasicServer

dir C:\DSCConfigs\BasicServer | select-string "\[File\]Reports"

#Let's go more advanced
psedit .\demo.ps1

#>