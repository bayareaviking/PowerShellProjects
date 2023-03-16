Return "This is a demo script file. Open this file in VSCode running PowerShell 7."

#pipeline variable
#Advanced content for special use-cases
#This is a one-line command.

1..10 | ForEach-Object -PipelineVariable a { $_ } |
ForEach-Object -pv b { $_ * $a } |
Select-Object @{Name = "Value"; Expression = { $a } },
@{Name = "Square"; Expression = { $b } },
@{Name = "Cubed"; Expression = { $b * $a } }


#this could have been broken down into multiple steps
#I'm using language elements you may not have learned yet.

$a = 1..10
$b = $a | ForEach-Object { $_ * $_ }

for ($i = 0; $i -lt $b.count; $i++) {
    $b[$i] | Select-Object @{Name = "Value"; Expression = { $a[$i] } },
    @{Name = "Square"; Expression = { $_ } },
    @{Name = "Cubed"; Expression = { $_ * $a[$i] } }
}

#PowerShell doesn't mean always using one-line commands

Clear-Host

# I have a command which can help identify variables you have created.
# Install-Module PSScriptTools -force
# Get-MyVariable -notypeinformation
