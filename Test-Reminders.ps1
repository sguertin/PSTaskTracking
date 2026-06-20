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
    $reminders = Get-Reminders;
    $overdueDate = $now.AddDays(-1);
    $dueReminders = Get-Reminders | Where-Object Date -LT $now;
    $overdueReminders = $reminders | Where-Object Date -LT $overdueDate;
    if ($overdueReminders.Count -gt 0) {
        Write-PSError ("You have " + $overdueReminders.Count + " reminders that are OVERDUE!");
        foreach ($reminder in $overdueReminders) {
            Write-PSError (ConvertTo-ReminderString $reminder);
        }
    }
    if ($dueReminders.Count -gt 0) {
        Write-PSWarning ("You have " + $dueReminders.Count + " reminders that are due!");
        foreach ($reminder in $dueReminders) {
            Write-PSWarning (ConvertTo-ReminderString $reminder);
        }
    }
    if (($overdueReminders.Count -eq 0) -and ($dueReminders.Count -eq 0) -and !$SilentAllClear) {
        Write-PSHost "No reminders due at this time!" -ForegroundColor Green;
    }
}
Set-Alias reminders -Value Test-Reminders;
