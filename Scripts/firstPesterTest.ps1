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

Describe 'Testing for Reaction Memes in OneDrive Folder' {
    It "has a reaction meme in OneDrive" {
        "C:\Users\Marcus\OneDrive\Pictures\Reaction Stills\AGratefulNationSalutesYou.jpg" | Should -Exist
    }

    It "Has a .jpg file extension" {
       ((("C:\Users\Marcus\OneDrive\Pictures\Reaction Stills\AGratefulNationSalutesYou.jpg").Split(".")[1]) -eq "jpg") | Should -Be $true
    }
}