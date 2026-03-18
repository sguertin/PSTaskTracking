function Get-ReminderFilePath {
    <#
    .SYNOPSIS
    Returns the file path for a reminder of a given Id
    
    .DESCRIPTION
    Retrieves the reminder with an Id and, optionally, a date if the reminder is not from today.
    
    .PARAMETER Id
    The Id of the reminder
    
    .PARAMETER Date
    The date of the reminder, if not today
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)][int]$Id,
        [Parameter(Position = 2)][DateTime]$Date = (Get-Date)
    )
    
    $timestamp = $Date.ToString("yyyy-MM-dd");
    return Join-Path (Get-ReminderFolder) -ChildPath "reminder-$timestamp.$Id.json"
}