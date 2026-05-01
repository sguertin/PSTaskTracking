function Sync-TaskTrackerSettings {
    [CmdletBinding()]
    param()

    $script:Settings = Get-TaskTrackerSettings;    
}