#variation using parameters
Configuration RSATConfig2 {

    Param([string[]]$RsatFeatures)

    Import-DSCresource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"

    Node Win10 {
        Script RSAT {
            #Values must be static
            TestScript = {
                $rsat = $using:RsatFeatures
                $packages = $rsat | ForEach-Object { Get-WindowsCapability -Online -Name $_ }
                if ($packages.state -contains "NotPresent") {
                    Return $False
                }
                else {
                    Return $True
                }
            } #test
            GetScript  = {
                $rsat = $using:RsatFeatures
                $installed = $rsat | ForEach-Object { Get-WindowsCapability -Online -Name $_ } |
                Where-Object { $_.State -eq 'installed' }
                [string]$getResult = "Installed: {0}" -f ($installed.Name -join ",")

                #must be hashtable with a Result key and string value
                Return @{Result = $GetResult }
            } #get
            SetScript  = {
                $rsat = $using:RsatFeatures
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

