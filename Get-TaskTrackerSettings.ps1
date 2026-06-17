function Get-TaskTrackerSettings {
    <#
    .SYNOPSIS
    Retrieves the current task tracker settings.
    
    .EXAMPLE
    Get-TaskTrackerSettings
    
    #>
    [CmdletBinding()]
    param()

    return Get-Content ($script:SettingsFile) | ConvertFrom-Json -AsHashtable;
}