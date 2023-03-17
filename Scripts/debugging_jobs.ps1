# Creating JOb using Wait-Debugger

$scriptBlock = {
    $var = 10
    Wait-Debugger
    $var
    $var + 1
    Write-Warning -Message "The new value of `$var is $var"
}

$job = Start-Job -ScriptBlock $scriptBlock -ErrorAction Stop -Verbose
Debug-Job -Job $job


