#advanced DSC configurations
#run in the scripting editor

Return "This is a walk-through demo script file"

psedit .\demodata.psd1
$data = Import-PowerShellDataFile .\demodata.psd1
$data
$data.allnodes
$node = ($data.allnodes).where({$_.nodename -eq 'srv1'})
$node
$node.services

#let's look at the configuration
psedit .\CompanyServer.ps1

