$path = "$env:OneDrive\Pictures\Reaction Stills"
$files = $(Get-ChildItem $path).Name
    foreach ($file in $files) {
        $extension = $file.Split(".")[1]
        $extension
    }
