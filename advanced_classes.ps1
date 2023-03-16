class TwittererRedux
{
    # Default constructor
    TwittererRedux ()
    {
        # Default, no values created
    }
    
    # Overloaded constructors
    # Constructor passing in Twitter handle
    TwittererRedux ([string]$TwitterHandle)
    {
        $this.TwitterHandle = $TwitterHandle   
    }

    # Constructor passing in Twitter handle and name
    TwittererRedux ([string]$TwitterHandle, [string]$Name)
    {
        $this.TwitterHandle = $TwitterHandle
        $this.Name = $Name
    }

    # Create a property
    [string]$TwitterHandle

    # Create a property with a default value
    [string]$Name = "Marcus Larsson"

<#     [string] TwitterURL()
    {
        # Call the function to build the Twitter URL
        # passing in the property we want
        $url = $this.TwitterURL($this.TwitterHandle)
        {
            return $url
        }
    } #>

    # Overloaded function that returns a string
    [string] TwitterURL($twitterHandle)
    {
        $url = "http://twitter.com/$($twitterHandle)"
        return $url 
    }

    # Function that has no return value
    [void] OpenTwitter()
    {
        Start-Process $this.TwitterURL()
    }

    # Can launch a Twitter page without instantiating the class
    static [void] OpenTwitterPage([string] $TwitterHandle)
    {
        $url = "https://twitter.com/$($TwitterHandle)"
        Start-Process $url 
    }
}

