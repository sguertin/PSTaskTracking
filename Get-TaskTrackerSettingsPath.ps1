function Get-TaskTrackerSettingsPath {
    [CmdletBinding()]
    param()

    return Join-Path (Get-TaskFolder) -ChildPath "settings.json";
}