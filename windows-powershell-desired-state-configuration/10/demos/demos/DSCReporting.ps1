#requires -version 5.1

#These are not production-ready commands
Function Get-DSCReportSummary {
    [cmdletbinding()]
    [OutputType("DSCReportSummary")]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [Microsoft.Management.Infrastructure.CimSession[]]$CimSession
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Try {
        Write-Verbose "Getting LCM information"
        $lcm = Get-DscLocalConfigurationManager -CimSession $CimSession -ErrorAction Stop
        $AgentID = $lcm.AgentId
        $RptUrl = $lcm.ReportManagers.serverURL

        $requestURI = "$RptURL/Nodes(AgentId='$AgentID')/Reports"

        $get = @{
            Uri             = $requestURI
            ContentType     = "application/json;odata=minimalmetadata;streaming=true;charset=utf-8"
            UseBasicParsing = $True
            Headers         = @{Accept = "application/json"; ProtocolVersion = "2.0" }
            ErrorAction     = "Stop"
        }

        Try {
            Write-Verbose "Getting report data from $requestURI"
            $data = Invoke-WebRequest @get
        }
        Catch {
            Throw $_
        }

        $content = ConvertFrom-Json $data.Content
        Write-Verbose "Found $($content.value.count) item(s)"

        foreach ($item in $content.value) {
            #Skip LocalConfigurationManager events
            if ($item.OperationType -ne 'LocalConfigurationManager') {
                Write-Verbose "Getting status data"
                $statusData = $item.StatusData | ConvertFrom-Json
                if ($statusdata.resourcesNotInDesiredState.Count -eq 0) {
                    $Valid = $True
                }
                else {
                    $Valid = $False
                }

                [pscustomobject]@{
                    PSTypeName        = "DSCReportSummary"
                    OperationType     = $item.OperationType
                    Status            = $item.Status
                    Start             = $item.StartTime -as [datetime]
                    End               = $item.EndTime -as [datetime]
                    RunTime           = New-TimeSpan -Start $($item.StartTime -as [datetime]) -End $($item.EndTime -as [datetime])
                    RebootRequested   = $item.RebootRequested
                    ResourcesPass     = $statusdata.resourcesInDesiredState.Count
                    ResourcesFail     = $statusdata.resourcesNotInDesiredState.Count
                    InCompliance      = $Valid
                    ConfigurationMode = $statusData.metaconfiguration.ConfigurationMode
                    Computername      = $statusData.hostname
                }
            }
        } #foreach
    } #Try
    Catch {
        Throw $_
    }

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}

