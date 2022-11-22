$products = Get-CimInstance -ClassName Win32_Product
$products.Name
$products.Version

Write-Warning -Message "This is all very silly"