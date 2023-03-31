
[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [ValidateScript({ 
            Try {
                Test-Path $_ -PathType Leaf -ErrorAction Stop
            }
            Catch {
                Throw "Nope, couldn't find it!"
            }
        })]
    [String]
    $Path,

    [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
    [ValidateSet('1', '2')]
    [String]
    $Generation,

    [Parameter(Mandatory, Position = 2, ValueFromPipeline)]
    [ValidateRange(32MB, 512MB)]
    [Int]
    $Range
)

Write-Output "The file exists at $Path"


