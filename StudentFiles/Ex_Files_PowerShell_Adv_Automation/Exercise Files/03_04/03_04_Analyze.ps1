$RunMe = Read-Host -Prompt 'What would you like to run today?'
Invoke-Expression -Command $RunMe

Get-MyUsers -OU Management

Get-Process -ComputerName dc01 | Out-File C:\ScriptOutput\Processes.txt

