#this configuration will be pulled by the node

Configuration PulledConfig {

   Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
   Import-DSCResource -ModuleName ComputerManagementDSC -ModuleVersion 8.5.0
   Import-DscResource -ModuleName NetworkingDSC -ModuleVersion 8.2.0

   #configurations can be generic
   Node Localhost {

      File Stuff {
         DestinationPath = "C:\Stuff"
         Ensure          = "Present"
         Type            = "Directory"
      }
      HostsFile Hosts {
         Hostname  = "SRV4.company.pri"
         IPAddress = "192.168.3.61"
         Ensure    = "Present"
      }
      WindowsEventLog Security {
         LogName            = "Security"
         IsEnabled          = $True
         MaximumSizeInBytes = 2gb
      }
      Service winmgmt {
         Name        = "winmgmt"
         State       = "Running"
         StartupType = "Automatic"
      }
   } #node
}

