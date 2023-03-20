
Configuration StopMaps
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {

        Service DisableMaps
        {
            Name        = "MapsBroker"
            StartupType = "Disabled"
            State       = "Stopped"
        }
    }
}














configuration InstalledRoles
{
    Param([string[]]$ComputerName = "srv01")
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $ComputerName
    {
        WindowsFeature HaveBitLocker 
            {
            Ensure = "Present"
            Name =  "BitLocker"
            }
        WindowsFeature NoWebServer 
            {
            Ensure = "Absent"
            Name =  "Web-Server"
            }
    }
}

