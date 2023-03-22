# Web requests and REST methods

$response = Invoke-WebRequest -Method Get -Uri www.mattallford.com
$response.Links
$response.RawContent
$response.Headers


## Getting an HTML response and transforming it into an XML feed, using the .Content property of the result
$result = Invoke-WebRequest -Method Get -Uri https://www.reddit.com/r/PowerShell/.rss
[xml]$xmlResult = $result.Content
$xmlResult.feed
$xmlResult.feed.entry  

## Using Invoke-Webrequest to download a file from the internet
Invoke-WebRequest -Uri 'https://github.com/PowerShell/PowerShell/releases/download/7.0.3/PowerShell-7.0.3-win-x64.msi' -OutFile ".\Data\PowerShell7.msi"

# Invoke-RestMethod testing, returning objects as native PSObjects
Invoke-RestMethod -Method Get -Uri https://devblogs.microsoft.com/powershell/feed
$githubREST = Invoke-RestMethod -Method Get -Uri https://api.github.com/users/mattallford
$githubREST | Get-Member | more 

# Same format with Invoke-WebRequest
$githubHTTP = Invoke-WebRequest -Method Get -Uri https://api.github.com/users/mattallford
#$github | Get-Member | more 

$githubHTTP.Content | ConvertFrom-Json

# using the POST method
$body = @{name = "PluralsightDemoRepo"} | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri https://api.github.com/user/repos -Body $body # Errors out, permissions issue
Start-Sleep 5

# Generate and convert API token
$token = "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"
$base64Token = [System.Convert]::ToBase64String([char[]]$token)

# Deleting the previously created repo
# Rest is stateless, it won't remember the last authentication so use the header info again
Invoke-RestMethod -Method Delete -Uri https://api.github.com/repos/bayareaviking/PluralsightDemoRepo -Headers $header 

# Create header from token (all this listed in the GitHub documentation, it varies)
$header = @{Authorization = "Basic $base64Token"}

# Now it will work
Invoke-RestMethod -Method Post -Uri https://api.github.com/user/repos -Body $body -Headers $header


# SIG # Begin signature block
# MIIF3gYJKoZIhvcNAQcCoIIFzzCCBcsCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAdyrQXxoXl1PX/
# QP8FYUnRiXsb1MRw5k0W5EZ1RXwv4KCCA0UwggNBMIICKaADAgECAhASBjJ1SwPt
# vE+hOi6j5r/kMA0GCSqGSIb3DQEBCwUAMCkxJzAlBgNVBAMMHlBvd2VyU2hlbGwg
# U2lnbmluZyBDZXJ0aWZpY2F0ZTAeFw0yMzAzMjEwMjUyMzRaFw0yNDAzMjEwMzEy
# MzRaMCkxJzAlBgNVBAMMHlBvd2VyU2hlbGwgU2lnbmluZyBDZXJ0aWZpY2F0ZTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANCh8asiWxXtoJ1x9Piy0gMH
# G58a4hldrclR7ft4uQGWvylt7VxOyrJ78KYJxda8RDFv73xo91/NOcvSWwI0CHF2
# eV8e3wLfrDoXFGUkjlkUMCtEzUhztvqtLdTJH2YBiyYmgu5JU5uA1YO7KsFdA04y
# bF5LAv1Z3kUbMbCtFqEPnDYNwQxwBKNhIJp01SqvUSKTADMczlcwGj5sLxzDAa/n
# fOE7iGBcWM5Fv2j9E93+WNbU/vBUVqYuyrUbPdgsZaTEhxKaTrTFHvxg2aIVb06P
# v/W1LuJ7hJFRRzpYUHHBl7maIxxMdZ10fTqDUjIMeSb6HXiGXY2EhOWjdiUcUSkC
# AwEAAaNlMGMwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0G
# A1UdEQQWMBSCEnNjcmlwdC5jb21wYW55LmNvbTAdBgNVHQ4EFgQU4LbM8RwE7isV
# Svs8aUoHD2OmgBowDQYJKoZIhvcNAQELBQADggEBAKWs6qIIBXyDotduBYpBpWt1
# XXRixt6tkGsD2y+ObIi/Vi6o+NDQy4aXi/V5zWRFsV/sI2fb+lHWWswX13OEFzLc
# tOMHZgVFFGVrDu59bKwDfuQfpCVJ506YHbxyRHXSrouA3yp/ovS9WZUqZVXuVWD5
# Mf507eaWWrLV0nRM6UJRoKYzpTWVICdqlxzVKf/G7cdxFO2x1KGcUEiUIfs3+EbO
# 5CRA9YERzXyukJTgad7hglpI+C8eMdNH6NonYkOADqcPEIKZSWoNhLJ0pt9wJxfO
# UWYG2NqkvNe2NuEqGfYLh5wVYJvADAodSJHWkDYZSTczqGRLdIXRgyKjRmlUGS8x
# ggHvMIIB6wIBATA9MCkxJzAlBgNVBAMMHlBvd2VyU2hlbGwgU2lnbmluZyBDZXJ0
# aWZpY2F0ZQIQEgYydUsD7bxPoTouo+a/5DANBglghkgBZQMEAgEFAKCBhDAYBgor
# BgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEE
# MBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEiBCCz
# DSkt2fhwexlld3SVZPSKgKwzGY5tAyp9ksPdm6Ar/jANBgkqhkiG9w0BAQEFAASC
# AQDLmLT+ry+QSNNAg/6MxQUgyypl+QASY+QqXjuXwRuGgnnJpocSQNG+8Dpd1cmx
# qdDxOUxictX2XfmwtPQYoJe3h1/A6Xh0FowC2jCNU7MIbafX4pqD8A9cAJza0Vje
# u6cCkzdRyYGp5pkgFtGg2w9Bn4h1/KpL8SXuNcpc6MEO53UeYOjz/YrDsMKrdnvj
# KvNgb3Xn2XmlzTnPWGYBPmuuUKA6uTyWskuw+IIjbFmxM8jxUTNZmVDe7rl7q3Hx
# tYVREgR8TPMFc7OnVmWNQUQ2hfwkOOSNjljhpfu2NOUSStRm44gHk67UZPeSTFwN
# meDFBtTHareN1DFvyxgDrsBt
# SIG # End signature block
