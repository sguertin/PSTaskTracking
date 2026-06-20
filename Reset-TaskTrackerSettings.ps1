function Reset-TaskTrackerSettings {
    <#
    .SYNOPSIS
    Reverts the TaskTrackerSettings to their defaults

    .EXAMPLE
    Reset-TaskTrackerSettings
    #>
    [CmdletBinding()]
    param()

    Write-PSHost "Restoring default settings..." -Command $MyInvocation.MyCommand
    if (Test-Missing -Path $script:SettingsFile) {
        New-Item -Path $script:SettingsFile -ItemType File -Force;
    }
    Set-Content -Path $script:SettingsFile -Value (ConvertTo-Json (Get-DefaultTaskTrackerSettings));

    return (Sync-TaskTrackerSettings);
}
