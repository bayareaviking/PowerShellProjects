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