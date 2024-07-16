#using the custom DSC resource

<#
Here is a simple sample
Configuration RSATConfig3 {

    Import-DSCresource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"
    Import-DSCResource -moduleName "CompanyRSAT" -moduleVersion "0.1.0"

    Node Win10 {
        RSAT Failover {
            Name = "Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0"
            State = 'NotInstalled'
        }
    }
}

#>

#using configuration data
Configuration RSATConfig3 {

    Import-DSCresource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"
    Import-DSCResource -moduleName "CompanyRSAT" -moduleVersion "0.1.0"

    Node $Allnodes.Where({ $true }).NodeName {
        $node.RsatInstall.foreach({
                #construct simple name
                RSAT $_.split(".")[1] {
                    Name  = $_
                    State = 'Installed'
                } #rsat resource
            })
    } #node
}

