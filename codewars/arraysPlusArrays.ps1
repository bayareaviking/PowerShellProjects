function array_plus_array($arr1, $arr2) {
    $r = 0
    foreach ($element in $arr1) {
        $r += $element
    }

    foreach ($element in $arr2) {
        $r += $element
    }

    return $r
}