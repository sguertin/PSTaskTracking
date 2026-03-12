function Test-Reminders { 
    [cmdletBinding()]
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
        Write-Warning ("You have " + $dueReminders.Count + " reminders that are due!");
        foreach ($reminder in $dueReminders) {
            Write-Warning ("Id: " + $reminder.Id + ": [" + $reminder.Date.ToString("G") + "]" + $reminder.Reminder);
        }
    }
    if (($overdueReminders.Count -eq 0) -and ($dueReminders.Count -eq 0) -and !$SilentAllClear) {
        Write-Host "No reminders due at this time!" -ForegroundColor Green;
    }
}
Set-Alias reminders -Value Test-Reminders;