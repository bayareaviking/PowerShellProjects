New-PSRoleCapabilityFile -Path C:\JEA\TechJEARole.psrc





# Create a folder in the local modules path for thismodule
$Srv1ModulePath = Join-Path $env:ProgramFiles "WindowsPowerShell\Modules\LandonHotelJEA"
New-Item -ItemType Directory -Path $Srv1ModulePath



# Create an empty module and manifest.
New-Item -ItemType File -Path (Join-Path $Srv1ModulePath "LHJEATechSupport.psm1")
New-ModuleManifest -Path (Join-Path $Srv1ModulePath "LandonHotelJEA.psd1") -RootModule "LHJEATechSupport.psm1"



# Create the RoleCapabilities folder and copy the PSRC file to it
$RoleCapFolder = Join-Path $Srv1ModulePath "RoleCapabilities"
New-Item -ItemType Directory $RoleCapFolder
Copy-Item -Path C:\Scripts\TechJEARole.psrc -Destination $RoleCapFolder