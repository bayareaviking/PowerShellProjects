#demo Invoke-DSCResource

Return "This is a walk-through demo script file"

help Invoke-DscResource

#run ON the node where you want to test
#Beware of potential 2nd hop issues if using PowerShell remoting
Get-DscResource File -Syntax

Enter-PSSession -ComputerName SRV1
cd \
#create a hashtable of settings you would set in a configuration
$Settings = @{
    DestinationPath = "C:\Work"
    Ensure          = "Present"
    Type            = "Directory"
}

$splat = @{
    Name       = "File"
    ModuleName = "PSDesiredStateConfiguration"
    Method     = "Test"
    Property   = $settings
    Verbose    = $True
}
Invoke-DscResource @splat

$splat.Method = "Get"
Invoke-DscResource @splat

#you can also use it to set
$set2 = @{
    DestinationPath = "C:\Work2"
    Ensure          = "Present"
    Type            = "Directory"
}
$splat.Property = $set2
$splat.Method = "Set"
Invoke-DscResource @splat
$splat.method = "test"
Invoke-DscResource @splat

#reset demo
#remove-item c:\work2 -Recurse -Force
Exit-PSSession
