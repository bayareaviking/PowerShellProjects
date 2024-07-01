using module .\Class\Twitterer.psm1

$twit = [Twitterer]::new("JackTalbain", "There Wolf")
$twit

$twit.OpenTwitter()

[Twitterer]::OpenTwitterPage("bayareaviking")

Get-Member $twit