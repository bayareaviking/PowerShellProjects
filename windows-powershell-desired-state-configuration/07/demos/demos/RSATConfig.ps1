# See https://docs.microsoft.com/powershell/scripting/dsc/reference/resources/windows/scriptresource?view=powershell-5.1
# for more information about the Script resource.

Configuration RSATConfig {

    Import-DSCresource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"

    Node Win10 {
        Script RSAT {
            #Values must be static
            TestScript = {
                $rsat = @(
                    'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0',
                    'Rsat.CertificateServices.Tools~~~~0.0.1.0',
                    'Rsat.DHCP.Tools~~~~0.0.1.0',
                    'Rsat.Dns.Tools~~~~0.0.1.0',
                    'Rsat.FileServices.Tools~~~~0.0.1.0',
                    'Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0',
                    'Rsat.ServerManager.Tools~~~~0.0.1.0'
                )
                $packages = $rsat | ForEach-Object { Get-WindowsCapability -Online -Name $_ }
                if ($packages.state -contains "NotPresent") {
                    Return $False
                }
                else {
                    Return $True
                }
            } #test
            GetScript  = {
                $rsat = @(
                    'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0',
                    'Rsat.CertificateServices.Tools~~~~0.0.1.0',
                    'Rsat.DHCP.Tools~~~~0.0.1.0',
                    'Rsat.Dns.Tools~~~~0.0.1.0',
                    'Rsat.FileServices.Tools~~~~0.0.1.0',
                    'Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0',
                    'Rsat.ServerManager.Tools~~~~0.0.1.0'
                )
                $installed = $rsat | ForEach-Object { Get-WindowsCapability -Online -Name $_ } |
                Where-Object { $_.State -eq 'installed' }
                [string]$getResult = "Installed: {0}" -f ($installed.Name -join ",")

                #must be hashtable with a Result key and string value
                Return @{Result = $GetResult }
            } #get
            SetScript  = {
                $rsat = @(
                    'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0',
                    'Rsat.CertificateServices.Tools~~~~0.0.1.0',
                    'Rsat.DHCP.Tools~~~~0.0.1.0',
                    'Rsat.Dns.Tools~~~~0.0.1.0',
                    'Rsat.FileServices.Tools~~~~0.0.1.0',
                    'Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0',
                    'Rsat.ServerManager.Tools~~~~0.0.1.0'
                )
                foreach ($item in $rsat) {
                    $pkg = Get-WindowsCapability -Online -Name $item
                    if ($item.state -ne 'Installed') {
                        Add-WindowsCapability -Online -Name $item
                    }
                } #foreach
            } #set
        } #script
    } #node
} #configuration

