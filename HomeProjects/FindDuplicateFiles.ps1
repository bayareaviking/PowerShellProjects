[CmdletBinding()]
param(
    [string]$Source = "$env:OneDrive\pictures",
    [string]$Target = "C:\tmpPics"
)

try {
    # Check if target path exists, create target path if it's not already there
    if (!(Test-Path -PathType Container -Path $Target)) { New-Item -ItemType Directory -Path $Target -Force | Out-Null }

    # Groups all files by length before calculating hash, reduces runtime
    Get-ChildItem -Path $Source -File -Recurse | Group-Object -Property Length `
    | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Group `
    | Get-FileHash | Group-Object -Property Hash | Where-Object { $_.Count -gt 1 } `
    | ForEach-Object { $_.Group | Select-Object -Skip 1 } `
    | Move-Item -Destination $Target -Force -Verbose
}
catch {
    Write-Warning -Message "Could not find or create the path $Target"
}