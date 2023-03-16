class Twitterer {
    # Create a propery
    [string]$TwitterHandle

    # Create a property and set a default value
    [string]$Name = "Marcus Larsson"

    # Function that returns a string
    [string] TwitterURL()
    {
        $url = "https://twitter.com/$($this.TwitterHandle)"
        return $url
    }

    # Function that returns no value
    [void] OpenTwitter()
    {
        Start-Process $this.TwitterURL()
    }
}

$twit = [Twitterer]::new()
$twit.TwitterHandle = "HaveNoLife"
$twit.TwitterHandle 

# See default name
$twit.Name

# Set new name
$twit.Name = "Mr. Lifestyle"
$twit.Name
