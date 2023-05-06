function New-PhoneNumber([int[]]$numbers) {
    [string]$output = "`("
    for ($i = 0; $i -lt 3; $i++) {
        $output += [string]$numbers[$i]
    }

    $output += "`) "

    for ($j = 3; $j -lt 6; $j++) {
        $output += [string]$numbers[$j]
    }

    $output += "`-"

    for ($k = 6; $k -lt 11; $k++) {
        $output += [string]$numbers[$k]
    }
  
    return $output
}

New-PhoneNumber 1, 2, 3, 4, 5, 6, 7, 8, 9, 0