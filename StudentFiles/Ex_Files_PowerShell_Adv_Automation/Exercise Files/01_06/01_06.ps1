# GUID copied and pasted from SMB pull server
# Paste GID here


[DSCLocalConfigurationManager()]
Configuration PullClientConfigID
{
    Node localhost
    {
        Settings
        {
            RefreshMode = 'Pull'
            ConfigurationID = '#paste GID here'
            RefreshFrequencyMins = 30
            RebootNodeIfNeeded = $true
            # ConfigurationMode = 'ApplyAndMonitor' --or-- 'ApplyAndAutoCorrect'
        }
        ConfigurationRepositoryShare SMBPullServer
        {
            SourcePath = '\\srv01\DscSmbPull'

        }
    }
}

PullClientConfigID

Set-DscLocalConfigurationManager -ComputerName localhost -Path .\PullClientConfigID

