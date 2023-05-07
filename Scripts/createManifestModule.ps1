# Creating a Manifest Module for the MyModule.psm1 file

[string]$myModulePath = $($env:PSModulePath.Split(';')[0]) + "\MyModule"

$myModulePath

$module = Get-Module -ListAvailable -Name MyModule
#$module | Select-Object *

$modulePath = $module.ModuleBase
#$modulePath

# Minimum recommended settings for creating new manifest
$params = @{
    'Author' = 'Marcus Larsson'
    'CompanyName' = 'BAV Computer Consulting'
    'Description' = 'This is a test module made for PS practice'
    'NestedModules' = 'MyModule'
    'Path' = "$modulePath\MyModule.psd1" 
}

New-ModuleManifest @params -Verbose