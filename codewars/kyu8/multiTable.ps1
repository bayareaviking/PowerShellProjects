  function Multi-Table ([int] $n) {
    for ($i = 1; $i -le 10; $i++) {
        $ans = $n * $i
        [string]$output += "$i * $n = $ans`n"
    }
    
    return $output.TrimEnd()
  }

  Multi-Table 4