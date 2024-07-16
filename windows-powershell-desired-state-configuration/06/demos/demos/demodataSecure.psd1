@{
    AllNodes    = @(
        @{
            NodeName                    = "*"
            Folders                     = "Work"
            RemoveFeatures              = "PowerShell-v2", "Telnet-Client"
            AddFeatures                 = "Windows-Server-Backup"
            MaxSecurityLog              = 1GB
            Services                    = "Bits", "Winrm"
            PSDscAllowPlainTextPassword = $false # <-- now false
            PSDscAllowDomainUser        = $false
        },
        @{
            #named node values take priority over duplicate items in *
            NodeName        = "SRV1"
            AddFeatures     = "NLB"
            Role            = "FilePrint"
            Services        = "Winmgmt"
            CertificateFile = "C:\certs\srv1.cer"
            Thumbprint      = "9F24C541113C1940E22B4436720E3E0496AD60DA"
        },
        @{
            NodeName        = "SRV2"
            Role            = "Dev"
            CertificateFile = "C:\certs\srv2.cer"
            Thumbprint      = "4822355C555B1A1FA86705FC08F327304D4CA351"
        }
    )
    NonNodeData = @{
        Domain       = "Company"
    }
}