function Past([int] $h, [int] $m, [int] $s) {

    return [int]$((Get-Date -Hour $h -Minute $m -Second $s) - (Get-Date -Hour 0 -Minute 0 -Second 0)).TotalMilliseconds
}

Past 6 24 55