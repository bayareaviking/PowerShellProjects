#my way to get a document encryption certificate installed from AD
Return "This is a walk-through demo script file"
#this code may not work over remoting unless CredSSP is enabled

#this is MY custom certificate template that supports DocumentEncryption (1.3.6.1.4.1.311.80.1)

$getParams = @{
    template          = 'DSCTemplate'
    url               = 'ldap:'
    CertStoreLocation = 'Cert:\LocalMachine\My\'
    Verbose           = $True
}

Get-Certificate @getparams

<#
You can install the ADCSTemplate module from the PowerShell Gallery to manage
CA templates from a PowerShell promptdir
#>