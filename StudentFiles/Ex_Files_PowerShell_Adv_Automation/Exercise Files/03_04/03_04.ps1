# Reason for analyzing
#    Scripts are growing
#    Human error
#    Scripts are to be shared
#    Quality standards are recognized as important

Install-Module -Name PSScriptAnalyzer

Get-Command -Module PSScriptAnalyzer

Get-ScriptAnalyzerRule
#  PSAvoidUsingCmdletAliases
#  PSAvoidGlobalFunctions -- read details
#  PSAvoidUsingComputerNameHardcoded -- error
#  PSAvoidUsingInvokeExpression -- security hole (code insertion)

Invoke-ScriptAnalyzer -Path ".\03_04-02.ps1"