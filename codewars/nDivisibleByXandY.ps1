function IsDivisible([int] $n, [int] $x, [int] $y) {
    if (($n % $x -eq 0) -and ($n % $y -eq 0)) {
        $val = $true
    }
    else {
        $val = $false
    }

    return $val
}

IsDivisible 12 3 4