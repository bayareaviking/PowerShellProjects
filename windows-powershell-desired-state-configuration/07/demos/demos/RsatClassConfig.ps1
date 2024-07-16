Configuration RSATConfig4 {

    Import-DSCresource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"
    Import-DSCResource -moduleName "CompanyRSATClass" -moduleVersion "0.1.0"

    Node $Allnodes.Where({ $true }).NodeName {
        $node.RsatInstall.foreach({
                #construct simple name
                CompanyRSATClass $_.split(".")[1] {
                    Name  = $_
                    State = 'Installed'
                } #rsat resource
            })
    } #node
}

