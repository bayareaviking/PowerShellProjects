function ExpressionMatter([int] $a, [int] $b, [int] $c) {
    $highVal = 0
    $allSums = @()

    $allSums += $a + $b + $c
    $allSums += $a * $b + $c
    $allSums += $a + $b * $c
    $allSums += $a * $b * $c
    $allSums += ($a * $b) * $c
    $allSums += $a * ($b * $c)
    $allSums += ($a * $b) + $c
    $allSums += $a + ($b * $c)
    $allSums += ($a + $b) * $c
    $allSums += $a * ($b + $c)

    foreach ($sum in $allSums) {
        if ($sum -gt $highVal) {
            $highVal = $sum
        }
    }
    
    return $highval
}