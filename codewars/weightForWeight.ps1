function order-weight($s) {
    # If $s is empty, return an empty string
    if ([string]::IsNullOrEmpty($s)) {
        return ""
    }

    # Split string into array of strings
    $strNum = $s.Split(" ")
    # Define temp array
    $temp = @()

    # Loop through the array of strings
    for ($i = 0; $i -lt $strNum.length; $i++) {
        # Create a weight(sum) value and attach it to the true weight of the string
        $sum = ($strNum[$i] -split '' | Measure-Object -Sum).Sum
        # Push the attached weight and weight string to a temp array
        $hash = [PSCustomObject]@{
            txtWeight = $strNum[$i]
            numWeight = $sum
        }
        $temp += $hash
    }

    # Sort by the weight number & if weight is the same, sort by string
    # Remove the string and pass it to a new array
    # Return joined array of new strings
    $output = ($temp | Sort-Object -Property numWeight, txtWeight).txtWeight -join " "

    return $output
}

order-weight "56 65 74 100 99 68 86 180 90"