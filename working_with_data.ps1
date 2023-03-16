# Working with Data

## Exporting, Importing, and Converting Data
### CSV files
<# $csvData = Get-Process -Name "w*" | Select-Object -Property Name, Handles, Company | ConvertTo-Csv
$csvData | Get-Member

$csvData | ConvertFrom-Csv | Get-Member #>

### XML Files
<# Get-Process a* | Export-Clixml -Path ".\process.xml"-Force 
Invoke-Item ".\process.xml"
$xmlData = Import-Clixml ".\process.xml"

$xmlData | Get-Member

$xmlData | Select-Object -Property Name,WorkingSet #>

# $convertedXml = Get-Process -Name "a*" | ConvertTo-Xml -As Document
# $convertedXml.Save(".\convertedXml.xml")
# Invoke-Item ".\convertedXml.xml"
# #Import-Clixml ".\convertedXml.xml"

# [xml]$xmlObject = Get-Content ".\convertedXml.xml"
# $xmlObject

### JSON files
Get-Date | Select-Object -Property * | ConvertTo-Json -AsArray

Get-Process -Name "w*" | ConvertTo-Json -AsArray | Tee-Object ".\procs.json"
$processData = Get-Content -Path ".\procs.json" | ConvertFrom-Json
$processData | Get-Member
$processData[0]