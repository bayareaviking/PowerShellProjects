#demonstrate using certificates to encrypt credentials
# run in the scripting editor
Return "This is a walk-through demo script file"

#OID '1.3.6.1.4.1.311.80.1'
Invoke-Command -scriptblock {
    Get-Childitem Cert:\LocalMachine\my |
    Where-Object { $_.EnhancedKeyUsageList.FriendlyName -contains "Document Encryption" -AND $_.notAfter -gt (Get-Date) } |
    Sort-Object NotAfter | Select-Object -first 1
} -computer SRV1,SRV2

If (-Not (Test-Path C:\Certs)) {
    New-Item -Path C:\ -Name Certs -ItemType Directory
}

#These are my helper functions
psedit .\Get-MachineCert.ps1
. .\Get-MachineCert.ps1

Get-CertificateThumbprint srv1 -enhancedusage "Document Encryption" | Select-Object -first 1
Export-RemoteCertificate -computername SRV1 -path c:\certs -enhancedusage "Document Encryption"
Export-RemoteCertificate -computername SRV2 -path c:\certs -enhancedusage "Document Encryption"

$srv1 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 'C:\certs\srv1.cer'
$srv1.Thumbprint

#an alternative technique
(New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 'C:\certs\srv2.cer').thumbprint

#I've hardcoded the thumbprints into the psd1 file
psedit .\demodataSecure.psd1
#the configuration
psedit .\companyserverSecure.ps1
