
New-PSSessionConfigurationFile -SessionType RestrictedRemoteServer -Path C:\JEA\JEAEndpoint1.pssc





Test-PSSessionConfigurationFile -Path C:\JEA\JEAEndpoint1.pssc # should yield True

