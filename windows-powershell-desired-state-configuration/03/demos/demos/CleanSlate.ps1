<#
 This is a script I wrote to reset my demo environment.
 During course development, my test virtual machines go
 through a lot of iterations. Short of rebuilding my
 entire lab setup, this script resets DSC elements for
 the virtual machines.

 I am leaving this script in the course downloads in
 the event you need to use it. If you are just beginning
 this course, you might not understand what this script
 is doing. But you should understand it by the end.
#>

#Reset the LCM

[DscLocalConfigurationManager()]
Configuration LCMReset {
    Param([string[]]$Computername)

    Node $Computername {
        Settings {
            RebootNodeIfNeeded            = $True
            ConfigurationMode             = "ApplyAndMonitor"
            ActionAfterReboot             = "ContinueConfiguration"
            RefreshMode                   = "Push"
            ConfigurationID               = ""
            ConfigurationDownloadManagers = @{}
            ResourceModuleManagers        = @{}
        }
    }
}

LCMReset -computername srv2, srv1, win10 -output $env:temp\LCMReset
Set-DscLocalConfigurationManager -Path $env:temp\LCMReset -Force -Verbose

#clear DSC documents
Remove-DscConfigurationDocument -Stage pending -CimSession SRV1, SRV2, Win10 -ErrorAction SilentlyContinue
Remove-DscConfigurationDocument -Stage current -CimSession SRV1, SRV2, Win10 -ErrorAction SilentlyContinue

Remove-Item $env:temp\LCMReset -Force -Recurse