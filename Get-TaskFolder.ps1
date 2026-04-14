function Get-TaskFolder {
    <#
    .SYNOPSIS
    Returns the path to the task folder
    
    .EXAMPLE
    Get-TaskFolder;
    
    #>
    [CmdletBinding()]
    param()
    
    return Join-Path $env:LOCALAPPDATA -ChildPath "PSTaskTracking"
}