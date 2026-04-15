function Reset-TaskTrackerSettings {
    <#
    .SYNOPSIS
    Reverts the TaskTrackerSettings to their defaults
    
    .EXAMPLE
    Reset-TaskTrackerSettings    
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "Restoring default settings..."
    Set-Content -Path (Get-TaskTrackerSettingsPath) -Value (ConvertTo-Json (Get-DefaultTaskTrackerSettings));

    Sync-TaskTrackerSettings;
}