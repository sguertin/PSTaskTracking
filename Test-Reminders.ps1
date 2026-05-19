function Test-Reminders {
    <#
    .SYNOPSIS
    Provides warnings if reminders have not been done.
    
    .DESCRIPTION
    Checks if reminders are still pending based on the time of day
    
    .PARAMETER SilentAllClear
    Silence output for reminders being pending
    
    .EXAMPLE
    Test-Reminders;
    
    .NOTES
    Aliased as reminders
    #> 
    [CmdletBinding()]
    param(
        [switch]$SilentAllClear
    )
    $now = Get-Date;
    $overdueReminders = Get-OverdueReminders;
    if ($overdueReminders.Count -gt 0) {
        Write-PSError ("You have " + $overdueReminders.Count + " reminders that are OVERDUE!");
        foreach ($reminder in $overdueReminders) {
            Write-PSError ("Id: " + $reminder.Id + ": [" + $reminder.Date.ToString($script:DateString) + "]" + $reminder.Reminder);
        }
    } 
    $dueReminders = Get-Reminders | Where-Object Date -LT $now;
    if ($dueReminders.Count -gt 0) {
        Write-PSWarning ("You have " + $dueReminders.Count + " reminders that are due!");
        foreach ($reminder in $dueReminders) {
            Write-PSWarning ("Id: " + $reminder.Id + ": [" + $reminder.Date.ToString($script:DateString) + "]" + $reminder.Reminder);
        }
    }
    if (($overdueReminders.Count -eq 0) -and ($dueReminders.Count -eq 0) -and !$SilentAllClear) {
        Write-PSHost "No reminders due at this time!" -ForegroundColor Green;
    }
}
Set-Alias reminders -Value Test-Reminders;