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
        Write-Error ("You have " + $overdueReminders.Count + " reminders that are OVERDUE!");
        foreach ($reminder in $overdueReminders) {
            Write-Error ("Id: " + $reminder.Id + ": [" + $reminder.Date.ToString("G") + "]" + $reminder.Reminder);
        }
    } 
    $dueReminders = Get-Reminders | Where-Object Date -LT $now;
    if ($dueReminders.Count -gt 0) {
        Write-Host ("You have " + $dueReminders.Count + " reminders that are due!") -ForegroundColor Yellow;
        foreach ($reminder in $dueReminders) {
            Write-Host ("Id: " + $reminder.Id + ": [" + $reminder.Date.ToString("G") + "]" + $reminder.Reminder) -ForegroundColor Yellow;
        }
    }
    if (($overdueReminders.Count -eq 0) -and ($dueReminders.Count -eq 0) -and !$SilentAllClear) {
        Write-Host "No reminders due at this time!" -ForegroundColor Green;
    }
}
Set-Alias reminders -Value Test-Reminders;