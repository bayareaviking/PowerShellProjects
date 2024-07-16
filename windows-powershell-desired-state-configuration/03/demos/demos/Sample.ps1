
Configuration Sample {

    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1

    Node SRV1 {
        #this is using a built-in DSC Resource
        File Demo {
            DestinationPath = "C:\DSCDemo"
            Ensure          = "Present"
            Type            = "Directory"
        }
    }

}