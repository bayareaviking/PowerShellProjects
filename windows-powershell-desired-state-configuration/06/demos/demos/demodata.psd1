@{
    AllNodes    = @(
        @{
            NodeName                    = "*"
            Folders                     = "Work"
            RemoveFeatures              = "PowerShell-v2", "Telnet-Client"
            AddFeatures                 = "Windows-Server-Backup"
            MaxSecurityLog              = 1GB
            Services                    = "Bits", "Winrm"
            #allow plain text passwords
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true
        },
        @{
            #named node values take priority over duplicate items in *
            NodeName    = "SRV1"
            AddFeatures = "NLB"
            Role        = "FilePrint"
            Services    = "Winmgmt"
        },
        @{
            NodeName = "SRV2"
            Role     = "Dev"
        }
    )
    NonNodeData = @{
        Domain       = "Company"
        TestPassword = "P@ssw0rd"
    }
}