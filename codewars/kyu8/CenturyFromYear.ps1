function Get-CenturyFromYear ([int]$year) {    
    [string]$txtYear = $year
    [string]$txtCentury = $txtYear.Substring(0, 2)
    if ($txtYear.endswith("0")) {
        $century = [int]$txtCentury
    } 
    else {
        $century = [int]$txtCentury + 1
    }
  
    return $century;
}

Get-CenturyFromYear(1900)