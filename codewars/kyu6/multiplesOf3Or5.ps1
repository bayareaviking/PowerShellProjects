function Get-SumOfMultiples($Value) {
    [int]$sum = 0
    for ($i = 0; $i -lt $Value; $i++) {
        if (($i % 3 -eq 0) -or ($i % 5 -eq 0)) {
            $sum += $i
            $i
        }
    }
    return $sum
}
Get-SumOfMultiples 10