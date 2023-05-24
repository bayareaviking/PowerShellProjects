$here = Split-Path -Parent $MyInvocation.MyCommand.Path
 Invoke-Pester -Path $here\pesterTraining.Tests.ps1 -Output Detailed