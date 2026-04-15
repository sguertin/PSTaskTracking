function Get-TaskTrackerSettings {
    <#
    .SYNOPSIS
    Retrieves 
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param()

    return Get-Content (Get-TaskTrackerSettingsPath) | ConvertFrom-Json;
}