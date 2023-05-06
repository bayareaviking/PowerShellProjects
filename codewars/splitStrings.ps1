function Split-String($string) {
    if ($string.length % 2) {
        $string += "_"
    }

    $tempArr = @() 
    $strArr = $string -split('')

    for ($i = 1; $i -lt $strArr.Length; $i += 2) {
        [string]$tempStr = "$($strArr[$i])$($strArr[$i + 1])"
        if ($tempStr -ne "") {
            $tempArr += $tempStr
        }
    }
    return $tempArr
}

Split-String "abc"
Split-String "abcdef"