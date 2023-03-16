

<# $obj = [pscustomobject]@{
    ComputerName = $env:COMPUTERNAME
    Version = $PSVersionTable.PSVersion
    ProcessCount = $(Get-Process -ErrorAction SilentlyContinue).count 
    ServiceCount = $(Get-Service -ErrorAction SilentlyContinue).count 
    TimeZone = (Get-TimeZone).DisplayName
    Uptime = Get-Uptime
}

$obj #>

$procs = Get-Process | Where-Object {$_.ws -ge 50MB}

foreach ($p in $procs) {
    [pscustomobject]@{
        ID = $p.Id
        Name = $p.Name
        MemoryMB = ($p.ws / 1MB) -as [int32]
        Runtime = (Get-date) - ($p.StartTime)
        ComputerName = $env:COMPUTERNAME
    }
}