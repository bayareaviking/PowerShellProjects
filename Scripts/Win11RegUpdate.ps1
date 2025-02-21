# As described in https://www.howtogeek.com/759925/how-to-install-windows-11-on-an-unsupported-pc/#registry-hack-for-unsupported-cpus-and-or-only-tpm-1-2
# This script will update the registry to allow Windows 11 to be installed on unsupported hardware, provided as-is with no warranty or guarantee
# This script will only work on Windows 10 -> 11, this script will only work if you have the correct permissions to update the registry 

New-ItemProperty -Path "HKLM:\SYSTEM\Setup\MoSetup" -Name "AllowUpgradesWithUnsupportedTPMOrCPU" -Value 1 -PropertyType DWORD -Force -Verbose
Get-itemproperty -Path "HKLM:\SYSTEM\Setup\MoSetup\AllowUpgradesWithUnsupportedTPMOrCPU" -Verbose