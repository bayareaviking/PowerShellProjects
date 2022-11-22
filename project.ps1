$products = Get-CimInstance -ClassName Win32_Product
$products.Name
$products.Version