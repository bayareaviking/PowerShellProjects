
 















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

