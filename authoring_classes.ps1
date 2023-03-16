Enum MyTwitters {
    MarcusLarsson
    IslandCityGhost
    LackOfLifestyle
}

# Get a list of names in the Enum MyTwitters
[MyTwitters].GetEnumNames()

# Get one entry
$tweet1 = [MyTwitters]::MarcusLarsson
$tweet2 = [MyTwitters]::LackOfLifestyle

Write-Output "One of my Twitter handles is $tweet1, another is $tweet2"
[enum]::IsDefined(([MyTwitters]), $tweet1)

$tweet5 = "Undefined"
[enum]::IsDefined(([MyTwitters]), $tweet5)