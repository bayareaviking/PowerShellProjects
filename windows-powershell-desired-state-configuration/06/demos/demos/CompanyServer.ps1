#this configuration is using Write-Host lines to make it easier to monitor what the
#configuration is doing. This is for demonstration purposes only.

Configuration CompanyServer {

    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName ComputerManagementDSC -ModuleVersion 8.5.0
    Import-DscResource -ModuleName NetworkingDSC -ModuleVersion 8.2.0

    #define a credential
    $Secure = ConvertTo-SecureString -String "$($configurationdata.nonNodeData.TestPassword)" -AsPlainText -Force
    $HelpDeskCredential = New-Object -TypeName Pscredential -ArgumentList HelpDesk, $secure

    Write-Host "Creating configuration for the $($configurationdata.nonNodeData.Domain) domain" -ForegroundColor Green

    Node $AllNodes.where({ $true }).NodeName {
        Write-Host "Configuring $($node.nodename)" -foreground Cyan

        LocalConfigurationManager {
            RebootNodeIfNeeded = $True
            ConfigurationMode  = "ApplyAndAutoCorrect"
            ActionAfterReboot  = "ContinueConfiguration"
            RefreshMode        = "Push"
        }

        Write-Host "Adding HelpDesk Local User Account on $($node.nodename)" -ForegroundColor yellow
        User HelpDesk {
            UserName             = "HelpDesk"
            Ensure               = "Present"
            Disabled             = $False
            Description          = "HelpDesk User Account"
            PasswordNeverExpires = $True
            Password             = $HelpDeskCredential
        }

        Write-Host "Adding HelpDesk Local User Account on $($node.nodename) to Administrators" -ForegroundColor yellow
        Group Administrators {
            GroupName        = "Administrators"
            MembersToInclude = "HelpDesk"
            DependsOn        = "[User]HelpDesk"
        }

        $Node.Services.foreach({
                Write-Host "Setting $_ to auto start on $($node.nodename)" -foreground yellow
                Service $_ {
                    Name        = $_
                    StartupType = "Automatic"
                    State       = "Running"
                }
            }) #foreach service

        Write-Host "Setting security event log size to $($node.MaxsecurityLog) on $($node.nodename)" -foreground yellow
        WindowsEventLog Security {
            LogName            = "Security"
            MaximumSizeInBytes = $node.MaxSecurityLog
            IsEnabled          = $True
        }

        Write-Host "Adding Hosts entry for SRV3 on $($node.nodename)" -foreground yellow
        HostsFile Hosts {
            Hostname  = "SRV3.company.pri"
            IPAddress = "192.168.3.60"
            Ensure    = "Present"
        }

        $node.folders.foreach({
                Write-Host "Creating folder $_ on $($node.nodename)" -ForegroundColor yellow
                File $_ {
                    DestinationPath = (Join-Path -Path "c:" -ChildPath $_)
                    Ensure          = "Present"
                    Type            = "Directory"
                }
            }) #foreach folder

        $node.RemoveFeatures.foreach({
                Write-Host "Removing feature $_ on $($node.nodename)" -ForegroundColor yellow
                WindowsFeature ($_).Replace("-", "") {
                    Ensure = "Absent"
                    Name   = $_
                }
            }) #foreach feature to remove

        $node.AddFeatures.foreach({
                Write-Host "Adding feature $_ on $($node.nodename)" -ForegroundColor yellow
                WindowsFeature ($_).Replace("-", "") {
                    Ensure               = "Present"
                    Name                 = $_
                    IncludeAllSubFeature = $True
                }
            }) #foreach feature to add
    } #node

    Write-Host "Processing Roles" -foreground Cyan
    Node $allnodes.Where({ $_.role -eq 'FilePrint' }).Nodename {
        Write-Host "Adding the FilePrint role to $($node.nodename)" -foreground yellow
        WindowsFeature FileServices {
            Name                 = "File-Services"
            Ensure               = "Present"
            IncludeAllSubFeature = $True
        }

        WindowsFeature PrintServices {
            Name                 = "Print-Server"
            Ensure               = "Present"
            IncludeAllSubFeature = $True
        }
    } #node FilePrint role

    Node $allnodes.Where({ $_.role -eq 'Dev' }).Nodename {
        Write-Host "Adding the Dev role to $($node.nodename)" -foreground yellow
        WindowsFeature Containers {
            Name                 = "Containers"
            Ensure               = "Present"
            IncludeAllSubFeature = $True
        }
        WindowsFeature InternalDB {
            Name                 = "Windows-Internal-Database"
            Ensure               = "Present"
            IncludeAllSubFeature = $True
        }
        File Data {
            DestinationPath = (Join-Path -Path "c:" -ChildPath "$($configurationdata.nonNodeData.domain)-Data")
            Ensure          = "Present"
            Type            = "Directory"
        }
    } #node Dev role
}

<#
#load configuration

CompanyServer -ConfigurationData .\demodata.psd1 -OutputPath c:\dscConfigs\companyserver

psedit C:\dscconfigs\companyserver\SRV1.mof
psedit C:\dscconfigs\companyserver\SRV2.mof

#you may want to checkpoint your lab or virtual machines
#make sure DSC resources are installed
Invoke-Command -ScriptBlock {
 #need to force TLS setting to download from the PowerShell Gallery
 [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 #force installing the nuget provider to avoid being prompted
 Install-PackageProvider -Name nuget -Force -ForceBootstrap
 #install the DSC modules
 Install-Module -Name ComputerManagementDSC -RequiredVersion 8.5.0 -force
 Install-Module -Name NetworkingDSC -RequiredVersion 8.2.0 -force
} -computername SRV1,SRV2

#verify
Invoke-Command -ScriptBlock {
 Import-Module ComputerManagementDSC,NetworkingDSC
 Get-Module ComputerManagementDSC,NetworkingDSC
} -computername SRV1,SRV2

Start-DscConfiguration -force -Wait -Verbose -Path C:\dscConfigs\companyserver

#but let's be more secure
psedit .\democerts.ps1

#>

