#deploy configurations and resources to Pull server
Return "This is a walk-through demo script file"

#region configurations

# configuration that will be pulled by a node
psedit .\PulledConfig.ps1

# load configuration
. .\PulledConfig.ps1

#create MOF
PulledConfig -output C:\DSCConfigs\PulledConfig

#rename mof to configuration ID or name (covered later)
$id = New-Guid
$new = Join-Path -path C:\DscConfigs\PulledConfig -ChildPath "$id.mof"
Rename-Item C:\DSCConfigs\PulledConfig\Localhost.mof -NewName $new -PassThru | Select name

#the mof needs a checksum
New-DscChecksum -Path $New -OutPath C:\DSCConfigs\PulledConfig -Force
dir C:\dscConfigs\PulledConfig

#copy the files to the web pullserver however you want
$config = Import-PowerShellDataFile .\pullConfigData.psd1

#using this path on the pull server
$config.allnodes[1].PullServerConfigurationPath

$s = New-PSSession -computername SRV2
# C:\Program Files\WindowsPowerShell\DscService\Configuration
Copy-Item -path C:\DSCConfigs\PulledConfig\* -Destination $config.allnodes[1].PullServerConfigurationPath -ToSession $s

#verify
Invoke-Command {Get-ChildItem $using:config.allnodes[1].PullServerConfigurationPath} -session $s

#make sure resources are copied

#endregion

#region resources

#copy resources
# https://docs.microsoft.com/powershell/scripting/dsc/pull-server/package-upload-resources?view=powershell-5.1

If (-Not (Test-Path C:\ModuleExports)) {
    New-Item -Path C: -Name ModuleExports -ItemType Directory
}

#create archive zip file and checksum
# ModuleName_version.zip
#I'm using this code to create the zip file
psedit .\CreateFlatZip.ps1

. .\CreateFlatZip.ps1

#Using a CSV file of module data as another technique
#first make sure I have local installations of the modules
import-csv .\moduledata.csv | Foreach-Object {
 $m = Get-Module -FullyQualifiedName @{ModuleName = $($_.modulename);ModuleVersion = $($_.ModuleVersion)} -ListAvailable
 If (-not $m) {
    Install-Module -Name $_.modulename -RequiredVersion $_.moduleversion -Force
 }
}

#export the modules
Import-Csv .\moduledata.csv | Export-DSCResourceModule -OutputPath C:\ModuleExports -passthru -verbose

#copy zip files and checksums to pull server
# $s = New-PSSession -computername SRV2
Copy-Item -path C:\ModuleExports\* -Destination "C:\Program Files\WindowsPowerShell\DscService\Modules" -ToSession $s -Force
#verify
Invoke-Command { Get-ChildItem "C:\Program Files\WindowsPowerShell\DscService\Modules" } -Session $s

Clear-Host

# Remove-PSSession $s


#endregion