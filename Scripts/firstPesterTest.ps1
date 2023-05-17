<# 
# Example of Describe statement, the wrapper for the test
Describe 'Test Name' { # First curly brace must be on the same line as the Describe keyword
    It 'has this condition' {
        'test for this condition' | Should xxx
        ## Examples of the three Should tests: Exist, Contain, and Be
        # Filename.txt | Should -Exist # Exist keyword
        # Filename.txt | Should -Contain 'some text' # Contain keyword
        Condition ($x -gt 1) | Should -Be $true # Be keyword
    }
}
#>
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$file = "C:\Users\Marcus\OneDrive\Pictures\Reaction Stills\*.jpg"

 Invoke-Pester -Path $here\pesterTraining.Tests.ps1