function Get-TaskListSettings {
    [CmdletBinding()]
    param()

    return Join-Path (Get-TaskFolder) -ChildPath "settings.json";
}