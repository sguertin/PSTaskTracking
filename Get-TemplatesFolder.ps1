function Get-TemplatesFolder {
    <#
    .SYNOPSIS
    Returns the path to the templates folder
    
    .EXAMPLE
    Get-TemplatesFolder;
    
    #>
    [CmdletBinding()]
    param()
    
    return Join-Path (Get-TaskFolder) -ChildPath "templates";
}