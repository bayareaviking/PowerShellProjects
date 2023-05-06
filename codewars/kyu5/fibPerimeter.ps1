function Get-Perimeter ($n) {
    # Ugly bruteforcing of the array :( 

    # Return hard-coded results for anything less than 2
    if ($n -le 0) {
        return 0
    }

    if ($n -le 1) {
        return 4
    }

    # Add first two Fibonacci numbers in the sequence: 0 and 1
    $fibo = @()
    $fibo += 0
    $fibo += 1
    [bigint]$sum = $fibo[0] + $fibo[1]

    # roll through and find results for n + 1 squares
    for ($i = 2; $i -le ($n +1); $i++)
        {
            $fibo += $fibo[$i - 1] + $fibo[$i - 2];
            $sum += $fibo[$i];
        } 

    # Return the sum times four (since we're finding perimeters of squares)
    return (4 * $sum)
}

Get-Perimeter 20