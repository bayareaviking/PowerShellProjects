Describe 'Testing for a File in the Reaction Memes in OneDrive Folder' {
    Context 'Setup' {
        It "has a reaction meme in OneDrive" {
            "$env:OneDrive\Pictures\Reaction Stills\$file" | Should -Exist
        }
    }

    Context 'Verifying' {
        It "has a .jpg file extension" {
            ($($file.Split(".")[1]) -eq "jpg") | Should -Be $true
        }
    }
}

Describe 'Ensuring the File Has a .jpg Extension' {

}