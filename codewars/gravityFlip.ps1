function flip([char] $dir, [int[]] $arr) {
    if ($dir -eq 'R') {
        [int[]]$value = $arr | Sort-Object
    }
    else {
        [int[]]$value = $arr | Sort-Object -Descending
    }

    return $value
}

flip 'R' 3, 2, 1, 2