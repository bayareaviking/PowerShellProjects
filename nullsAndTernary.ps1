
<#
$products = Get-CimInstance -ClassName Win32_Product -ErrorAction SilentlyContinue
$products.Name
$products.Version
#>
Write-Warning -Message "This is all very silly"

# We are looking for more stuff to write
#Get-Service

if (Test-Connection 1.1.1.999 -Count 1 -ErrorAction SilentlyContinue) {
    # Successful
    Write-Output "It works!"
} 
else {
    # Failure
    Write-Warning -Message "It failed!"
    Write-Output "Have you thought about a career change? Maybe pumping gas?"
}


$n = $null
$n ?? (Write-Warning -Message "`$n is NULL")


$ht = @{}
$ht = @{Name = "Jeff"; Count = 3; "Sample Entry" = "This is a thing you can do" }
$ht
