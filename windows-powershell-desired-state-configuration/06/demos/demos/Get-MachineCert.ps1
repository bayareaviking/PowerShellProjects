#requires -version 4.0
#requires -module PKI

#get machine cert thumbprint and export cert
Function Export-RemoteCertificate {
    [cmdletbinding(SupportsShouldProcess)]
    Param(

        [Parameter(Position = 0)]
        [ValidateNotNullorEmpty()]
        [Alias("cn")]
        [string]$computername = $env:COMPUTERNAME,
        [ValidateSet("Server Authentication", "Document Encryption")]
        [string]$EnhancedUsage = "Server Authentication",
        [ValidateScript({ Test-Path $_ })]
        [string]$Path = "C:\Certs"
    )

    Try {
        #assumes a single certificate so sort on NotAfter
        Write-Verbose "Querying $computername for Machine certificates"
        $cert = Invoke-Command {
            #get server authentication certs that have not expired
            Get-ChildItem Cert:\LocalMachine\my |
            Where-Object { $_.EnhancedKeyUsageList.FriendlyName -contains $using:EnhancedUsage -AND $_.notAfter -gt (Get-Date) } |
            Sort-Object NotAfter | Select-Object -First 1
        } -ComputerName $computername -ErrorAction Stop
        Write-Verbose ($cert | Out-String)
    }
    Catch {
        Throw $_
    }

    if ($cert -AND $Test) {
        Try {
            Test-Certificate $cert -ErrorAction Stop
        }
        Catch {
            Throw $_
        }
    }
    if ($cert) {
        $exportPath = Join-Path -Path $Path -ChildPath "$computername.cer"
        Write-Verbose "Exporting certificate for $($cert.subject.trim()) to $exportpath"
        [pscustomobject]@{
            Computername = $cert.Subject.Substring(3)
            Thumbprint   = $cert.Thumbprint
            Path         = Export-Certificate -Cert $cert -FilePath $exportPath
        }
    }
    else {
        Write-Warning "Failed to find or verify a matching certificate on $($computername.toUpper())"
    }
} #Export-RemoteCertificate

Function Get-CertificateThumbprint {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0)]
        [ValidateNotNullorEmpty()]
        [Alias("cn")]
        [string]$computername = $env:COMPUTERNAME,

        [ValidateSet("Server Authentication", "Document Encryption")]
        [string]$EnhancedUsage = "Server Authentication",

        [Switch]$Test
    )

    Try {
        #assumes a single certificate so sort on NotAfter
        Write-Verbose "Querying $computername for $EnhancedUsage certificates"
        $certs = Invoke-Command {
            #get server authentication certs that have not expired
            Get-ChildItem Cert:\LocalMachine\my |
            Where-Object { $_.EnhancedKeyUsageList.FriendlyName -contains $using:EnhancedUsage -AND $_.notAfter -gt (Get-Date) } |
            Sort-Object NotAfter
        } -ComputerName $computername -ErrorAction Stop
    }
    Catch {
        Throw $_
    }

    If ($certs) {
        foreach ($cert in $certs) {
            Write-Verbose "Found certificate $($cert.thumbprint)"
            if ($test) {
                $IsValid = Test-Certificate $cert
            }
            else {
                $IsValid = "Unknown"
            }
            [pscustomobject]@{
                Subject          = $cert.Subject
                Thumbprint       = $cert.Thumbprint
                EnhancedKeyUsage = $cert.EnhancedKeyUsageList
                Verified         = $isValid
            }
        }
    }
    else {
        Write-Warning "Failed to find or verify a matching certificate on $($computername.toUpper())"
    }

}#Get-CertThumbnail

