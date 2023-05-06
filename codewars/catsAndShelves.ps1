function Jump($start, $finish) { 

    [bool]$sameSide = $start % 2 -eq $finish % 2
    [int]$jumps = [int][Math]::Ceiling(($finish - $start) / [float]3)

    if ($sameSide -and $jumps % 2 -eq 1) { $jumps++ }
    if (!$sameSide -and $jumps % 2 -eq 0) { $jumps++ }

    return $jumps
}