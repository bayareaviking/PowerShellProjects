$products = Get-CimInstance -ClassName Win32_Product
$products.Name
$products.Version

Write-Warning -Message "This is all very silly"

# We are looking for more stuff to write
Get-Service

if (Test-Connection 1.1.1.1) {
    # Successful
    Write-Output "It works!"
} 
else {
    # Failure
    Write-Warning -Message "It failed!"
}