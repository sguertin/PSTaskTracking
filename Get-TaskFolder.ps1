function Get-TaskFolder {
    <#
    .SYNOPSIS
    Returns the path to the task folder
    
    .EXAMPLE
    Get-TaskFolder;
    
    #>
    [CmdletBinding()]
    param()
    if ([string]::IsNullOrEmpty($env:LOCALAPPDATA)) {
        $AppData = Join-Path -Path $env:HOME -ChildPath ".local";
    } else {
        $AppData = $env:LOCALAPPDATA;
    }
    return Join-Path ($AppData) -ChildPath "PSTaskTracking"
}