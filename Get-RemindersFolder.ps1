function Get-RemindersFolder {
    <#
    .SYNOPSIS
    Returns the path of the reminders folder
    
    .EXAMPLE
    Get-RemindersFolder;
    
    #>
    [CmdletBinding()]
    param()
    return Join-Path -Path (Get-TaskFolder) -ChildPath "reminders";
}