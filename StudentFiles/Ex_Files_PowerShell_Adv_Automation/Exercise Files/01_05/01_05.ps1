New-Guid


Configuration ConfiguredServer
{
    Param([string[]]$ComputerName = "srv02")
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $ComputerName
    {
        Service NoMapsDownload
        {
            Name        = "MapsBroker"
            StartupType = "Disabled"
            State       = "Stopped"
        }
        Service HaveBITS 
        {
            Name =  "BITS"
            StartupType = "Automatic"
            State       = "Running"
        }
        WindowsFeature NoWebServer 
        {
            Ensure = "Absent"
            Name =  "Web-Server"
        }
    }
}



ConfiguredServer

New-DscChecksum -Path .\ConfiguredServer\ #Place .mof filename here
