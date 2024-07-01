class Twitterer
{
    # Default Constructor
    Twitterer()
    {

    }

    # Constructor passing in Twitter handle
    Twitterer([string]$TwitterHandle)
    {
        $this.TwitterHandle = $TwitterHandle
    }

    # Constructor passing in Twitter handle and name
    Twitterer([string]$TwitterHandle, [string]$Name) {
        $this.TwitterHandle = $TwitterHandle
        $this.Name = $Name
    }

    # Create a property
    [string]$TwitterHandle = "marcuslarsson"

    # Create a property and set a default value
    [string]$Name = 'Marcus Larsson'

    # Static property for version number
    static[string]$Version = '2024.07.01.001'

    # Function that returns a string
    [string]TwitterURL()
    {
        # Call the function to build the url
        # passsing in the property we want
        $url = $this.TwitterURL($this.TwitterHandle)
        return $url
    }

    [string]TwitterURL($twitterHandle) {
        $url = "https://twitter.com/$($this.twitterHandle)"
        return $url
    }

    # Function that has no return value
    [void]OpenTwitter()
    {
        Start-Process $this.TwitterURL()
    }

    static[void]OpenTwitterPage([string]$TwitterHandle)
    {
        # Can't call $this.TwitterHandle since the class has not been instantiated
        $url = "https://twitter.com/$($TwitterHandle)"
        Start-Process $url
    }
}