function Get-ReminderFolder {
    <#
    .SYNOPSIS
    Returns the path of the reminders folder
    
    .EXAMPLE
    Get-ReminderFolder;
    
    #>
    [CmdletBinding()]
    param()
    return Join-Path -Path (Get-TaskFolder) -ChildPath "reminders";
}