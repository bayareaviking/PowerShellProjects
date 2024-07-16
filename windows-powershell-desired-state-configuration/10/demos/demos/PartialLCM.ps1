[DSCLocalConfigurationManager()]
configuration PartialConfig {
    Param([string[]]$Computername)

    Node $Computername {

        <#
        I'm changing back to Push configuration for these
        configurations. Read the Microsoft documentation for 
        an example on how to setup partial configurations in Pull mode.
        #>
        PartialConfiguration ServiceConfiguration { #<-- Name must match eventual configuration
            Description = 'Configuration to configure services.'
            RefreshMode = 'Push'
        }
        PartialConfiguration FeaturesConfiguration { #<-- Name must match eventual configuration
            Description = 'Configuration for Windows Features'
            RefreshMode = 'Push'
        }

        Settings {
            RebootNodeIfNeeded   = $True
            ConfigurationMode    = 'ApplyAndAutoCorrect'
            AllowModuleOverwrite = $True
        }

    } #node
} #configuraion
