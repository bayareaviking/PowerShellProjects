function Convert-StringToCamelCase($String) {

    $splitString = $String.split("_")
    for ($i = 1; $i -lt $splitString.length; $i++) {
        $splitString[$i] = ($splitString[$i]).Substring(0, 1).ToUpper() + ($splitString[$i]).Substring(1)
    }
    [string]$String = -join $splitString

    $splitString = $String.split("-")
    for ($i = 1; $i -lt $splitString.length; $i++) {
        $splitString[$i] = ($splitString[$i]).Substring(0, 1).ToUpper() + ($splitString[$i]).Substring(1)
    }
    [string]$String = -join $splitString
  
  return $String
}

Convert-StringToCamelCase "the-stealth-warrior"
Convert-StringToCamelCase "The_Stealth_Warrior"
Convert-StringToCamelCase "The_Stealth-Warrior"
Convert-StringToCamelCase "A-B-C"
Convert-StringToCamelCase "The-Stealth-Warrior"
Convert-StringToCamelCase ""