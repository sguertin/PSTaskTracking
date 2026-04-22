function Sync-TaskTrackerSettings {
    [CmdletBinding()]
    param()

    $fileSettings = Get-TaskTrackerSettings;

    $Settings = $fileSettings;    
}