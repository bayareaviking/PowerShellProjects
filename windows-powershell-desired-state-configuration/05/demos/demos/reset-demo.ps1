#reset demo
Invoke-Command -scriptblock {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Uninstall-Module ComputerManagementDSC,NetworkingDSC -force
    Get-SmbShare -Name DemoFiles | Remove-SmbShare -force
    If (Test-Path c:\demofiles) {
        Remove-item c:\demofiles -Recurse -force
    }

    $f = @"
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost
"@

Set-Content -Path c:\windows\system32\drivers\etc\hosts -value $f
} -computername SRV1

. .\LCMReset.ps1
LCMReset -output $env:temp
Set-DscLocalConfigurationManager -Path $env:temp 
Remove-item $env:temp\SRV1.meta.mof

If (Test-Path C:\DSCConfigs) {
    Remove-Item c:\dscconfigs -recurse -force
}

