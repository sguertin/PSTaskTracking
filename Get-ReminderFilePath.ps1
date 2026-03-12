function Get-ReminderFilePath {
    [cmdletBinding()]
    param(
        [int]$Id,
        [DateTime]$Date = (Get-Date)
    )
    
    $timestamp = $Date.ToString("yyyy-MM-dd");
    return Join-Path (Get-ReminderFolder) -ChildPath "reminder-$timestamp.$Id.json"
}