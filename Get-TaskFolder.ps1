function Get-TaskFolder {
    <#
    .SYNOPSIS
    Returns the path to the task folder
    
    .EXAMPLE
    Get-TaskFolder;
    
    #>
    [CmdletBinding()]
    param()
    $userDirectory = $env:USERPROFILE
    return Join-Path $userDirectory -ChildPath "dailytasks"
}