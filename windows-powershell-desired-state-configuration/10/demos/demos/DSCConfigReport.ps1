#requires -version 5.1

<#
This version of the script assumes the server has a DSC configuration.
Write-Progress is turned off unless you use -Verbose

ToDo: Group resources by type
#>

#Usage: .\DSCConfigReport -cimsession SRV1 -path C:\Reports

[cmdletbinding()]
Param(
  [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the remote server name or CIMSession.")]
  [validatenotNullorEmpty()]
  [alias("CN", "Computername")]
  [Microsoft.Management.Infrastructure.CimSession]$Cimsession,

  [Parameter(HelpMessage = "The path for the HTML report. Do NOT include the filename")]
  [validatenotNullorEmpty()]
  [string]$Path = ".",

  [switch]$Passthru
)

$savedProgPref = $ProgressPreference

if ($PSBoundParameters["Verbose"]) {
  $global:ProgressPreference = "Continue"
}
else {
  $global:ProgressPreference = "SilentlyContinue"
}

#region private helper functions
function mkList {
  Param([object]$object)

  #strip off the : on the property name
  [xml]$xml = ($object | ConvertTo-Html -Fragment -As List) -replace "(?<=\w+):\<", "<"
  #insert a class name for the first column element
  for ($i = 0; $i -lt $xml.table.tr.count; $i++) {
    $a = $xml.CreateAttribute("class")
    $a.Value = "property"
    [void]$xml.table.tr[$i].FirstChild.Attributes.append($a)
  }

  $xml.InnerXml
}

function getTZ {
  $tz = Get-TimeZone
  if ((get-date).IsDaylightSavingTime()) {
    $tz.daylightname
  }
  else {
    $tz.Standardname
  }
}
#endregion

#get the script name for Verbose messaging
$thisScript = $myinvocation.MyCommand.name.split(".")[0]

#normalize the path
$path = Convert-Path -Path $path
#pull the computername value
$computername = $Cimsession.ComputerName

Try {
  Write-Host "Getting DSC Configuration data from $($Computername.toUpper())" -ForegroundColor Cyan
  Write-Verbose "[$thisScript] Getting configuration details"
  $config = Get-DscConfiguration -CimSession $Computername -ErrorAction stop
}
Catch {
  Throw $_
  #exit if there was an error getting the configuration
  return
}

if ($config) {
  Write-Verbose "[$thisScript] Getting Test results"
  $status = Get-DscConfigurationStatus -CimSession $Computername -ErrorAction Stop
  $test = Test-DscConfiguration -CimSession $Computername -Detailed -ErrorAction Stop
  $noncompliant = $test.ResourcesNotInDesiredState.ResourceID

  $server = $config[0].PSComputerName.ToUpper()
  $IP = ($status.IPV4Addresses).where({ $_ -notmatch "^127" }) -join ","
  $mode = $status.MetaConfiguration.RefreshMode
  #parse the metadata property string and turn it into an object
  $a = $status.MetaData.split(";").trim() | Where-Object { $_ }
  $hash = [ordered]@{
    IPAddress              = $IP
    Mode                   = $mode
    ConfigurationMode      = $status.MetaConfiguration.ConfigurationMode
    ConfigurationFrequency = $status.MetaConfiguration.ConfigurationModeFrequencyMins
    RefreshFrequency       = $status.MetaConfiguration.RefreshFrequencyMins
  }
  foreach ($line in $a) {
    $split = ($line -split ":").trim()
    $hash.add($split[0], $split[1])
  }
  $meta = New-Object -TypeName PSObject -Property $hash

  #define a summary
  $summary = [pscustomobject]@{
    Status                     = $status.Status
    LastOperation              = $status.StartDate
    Type                       = $status.Type
    RebootRequested            = $status.RebootRequested
    ResourcesInDesiredState    = $status.ResourcesInDesiredState.count
    ResourcesNotInDesiredState = $status.ResourcesNotInDesiredState.count
  }

  $file = Join-Path -Path $Path -ChildPath "$server.html"
  #attempt to resolve the name to a FQDN
  Try {
    Write-Verbose "[$thisScript] Resolving $server"
    $dns = Resolve-DnsName -Name $server -Type A -ErrorAction stop
    $FQDN = $dns.name.ToUpper()
  }
  Catch {
    #ignore any errors
    Write-Verbose "[$thisScript] Failed to resolve $server"
    $FQDN = $server
  }

  #embedded CSS code
  $head = @"
<Title>$Server DSC Configuration Report</Title>
<style>
body {
  background-color:#FFFFFF;
  font-family:Tahoma;
  font-size:11pt;
}
td {
  border:0px solid black;
    border-collapse:collapse;
    padding: 10px;
    }
th {
  color:white;
  border:1px solid black;
  border-collapse:collapse;
  background-color:black;
  padding: 5px;
}
tr:nth-child(odd) {background-color: lightgray}
table { margin-left:35px; }
.alert { color:red;}
.ok { color:green;}
.property {font-weight:bold;}
</style>
"@

  $frag = [System.Collections.Generic.list[string]]::New()

  $frag.Add("<H1>DSC Configuration Report</H1>")
  if ($test.InDesiredState) {
    $frag.add("<H2 class='ok'>")
  }
  else {
    $frag.add("<H2 class='alert'>")
  }
  $frag.add(@"
$FQDN
</H2>
<HR>
"@
  )

  $frag.add("<H3>Status Summary</H3>")
  $frag.Add($(mkList $summary))
  $frag.add("<H3>Local Configuration Manager</H3>")
  $frag.Add($(mklist $meta))

  #system properties to exclude from the output
  $exclude = "ResourceID", "CIM*", "PS*computername", "ConfigurationName",
  "ModuleName", "ModuleVersion"
  Write-Verbose "[$thisScript] Processing results"
  foreach ($setting in $config) {

    if ($noncompliant -contains $setting.ResourceId) {
      $frag.add("<H3 class='alert'>$($setting.resourceID)</H3>")
    }
    else {
      $frag.add("<H3>$($setting.resourceID)</H3>")
    }

    $defined = $setting.CimInstanceProperties.where({ $_.value }) |
    Sort-Object -Property Name | Select-Object -ExpandProperty Name

    $obj = $defined | ForEach-Object -Begin {
      #create a temporary hashtable
      $hash = [ordered]@{}
    } -Process {
      #exclude properties
      if ($exclude -notcontains $_ ) {
        #get the corresponding value from the setting
        $val = $setting.$_
        #test if value is an array
        if ($val -is [array]) {
          $val = $val -join ","
        }
        #add it to the hashtable
        $hash.Add($_, $val)
      }
    } -End {
      #decide if output should be a table or list depending on
      #the number of properties
      if ($hash.keys.count -gt 6) {
        $out = mkList $(New-Object -TypeName PSObject -Property $hash)
      }
      else {
        $out = New-Object -TypeName PSObject -Property $hash |
        ConvertTo-Html -As Table -Fragment
      }

      #convert to an object and html
      $frag.add($out)
    }

  }

  $frag.add(@"
<hr/><h5>
<i>
Items in red indicate non-compliant resources.<p/>
Report run: $(Get-Date) $(getTZ)
</i></h5>
"@
  )

  Write-Verbose "[$thisScript] Creating HTML file $file"
  ConvertTo-Html -Head $head -Body $frag |
  Out-File -FilePath $file -Encoding ascii

  if ($passthru) {
    Get-Item -Path $file
  }
}
else {
  #this should almost never run
  Write-Warning "No configuration data found"
}

Write-Verbose "[$thisScript] Report complete."
Write-Verbose "[$thisScript] Exiting report script"

#reset progress preference
$global:ProgressPreference = $savedProgPref
