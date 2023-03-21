
# Path to script
$scriptPath = "C:\Scripts\PowerShellTraining\Scripts\script_signing.ps1"

#G Generate a new self-signed cert
New-SelfSignedCertificate -DnsName 'script.company.com' -CertStoreLocationq Cert:\CurrentUser\My -Type CodeSigningCert -Subject  "PowerShell Signing Certificate"

