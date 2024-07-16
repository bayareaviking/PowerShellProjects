#requires -version 5.1
#requires -module PSDesiredStateConfiguration

<#
According to the MS documentation, Windows PowerShell 5.1 does not 
require a flat zip structure, i.e. no version folder. But in my
testing this does not appear to be true.

This function will create a zip file of the DSC resource without
the version folder. It will save the file to an output folder
and create the DSC checksum file.
#>

Function Export-DSCResourceModule {
    #this should support -WhatIf
    [cmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$ModuleName,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$ModuleVersion,
        [Parameter(HelpMessage = "Specify the output folder")]
        [ValidateScript({ Test-Path $_ })]
        [string]$OutputPath,
        [switch]$Passthru
    )

    Begin { }

    Process {

        $tmpDir = Join-Path -Path $env:temp -ChildPath $ModuleName
        if (-Not (Test-Path $tmpDir)) {
            Write-Verbose "Creating temporay location $tmpDir"
            [void](New-Item -Path $env:temp -Name $ModuleName -ItemType Directory)
        }
        Try {
            #need to take modules installed without a version subfolder
            $modtest = Get-Module -FullyQualifiedName @{ModuleName = $ModuleName;ModuleVersion= $ModuleVersion} -ListAvailable
            if ($modtest) {
                $modPath = Split-Path -path $modtest.path -Parent
                Write-Verbose "Getting DSC module from $modPath"
                $mod = Get-ChildItem -Path $modPath -ErrorAction Stop
            }
            else {
                Write-Error "Can't find module $moduleName version $moduleversion"
            }
        }
        Catch {
            Throw $_
        }
        if ($mod) {
            Write-Verbose "Copying to $tmpDir"
            $mod | Copy-Item -Destination $tmpDir -Container -Recurse -Force

            $out = Join-Path -Path $OutputPath -ChildPath ("{0}_{1}.zip" -f $ModuleName, $ModuleVersion)
            if (Test-Path $out) {
                #delete any old versions
                Remove-Item $out
            }
            Compress-Archive -Path $tmpDir -DestinationPath $out
            Write-Verbose "Creating the checksum"
            New-DscChecksum -Path $out -force

            Write-Verbose "Removing $tmpDir"
            Remove-Item $tmpDir -Recurse -Force

            if ($passthru) {
                Get-Item $out*
            }
        }
    }
    End {  }
}