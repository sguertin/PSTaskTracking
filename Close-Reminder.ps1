function Close-Reminder {
    <#
    .SYNOPSIS
    Closes a reminder

    .DESCRIPTION
    Closes a reminder by either piping the reminder file to this command or passing an Id and,
    optionally a Date if the reminder is not from today, and it will be moved to closed.

    .PARAMETER File
    A piped reminder file

    .PARAMETER Id
    The Id for the file

    .PARAMETER Date
    The date for the reminder, only necessary if reminder is for a different day.

    .EXAMPLE

    Get-OverdueReminders | Close-Reminder;

    # Close reminder with id of 1
    Close-Reminder -Id 1;

    # Close reminder with an id of 2
    Close-Reminder 2;

    # Close reminder 3 from yesterday
    Close-Reminder -Id 3 -Date (Get-Date).AddDays(-1);

    .NOTES
    Aliased as finish
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        [int]$Id,
        [Parameter(Position = 2)]
        [DateTime]$Date = (Get-Date)
    )
    $timestamp = $Date.ToString($script:DateStamp);
    $closedReminderPath = Join-Path $script:ClosedFolder -ChildPath "closed-reminders-$timestamp.json";
    if (Test-Path $closedReminderPath) {
        $closedReminders = Get-Content $closedReminderPath | ConvertFrom-Json;
    } else {
        $closedReminders = @();
    }
    $reminders = Get-Reminders;
    $reminder = $reminders | Where-Object Id -EQ $Id;
    if ($reminder.Length -eq 0) {
        throw "No reminder found for Id of '$Id'!"
    }
    $reminder.Resolution = (Read-Host "How was this reminder resolved?");
    $closedReminders += $reminder;
    $closedContent = ConvertTo-Json $closedReminders;
    if ($closedReminders.Length -eq 1) {
        $closedContent = "[$closedContent]";
    }
    Set-Content $closedReminderPath -Value $closedContent;
    $remainingReminders = $reminders | Where-Object Id -NE $Id;
    $remainingContent = ConvertTo-Json $remainingReminders;
    # A list of one object gets converted into a single object not a list
    if ($remainingReminders.Length -le 1) {
        $remainingContent = "[$remainingContent]";
    } else {
        $remainingContent = ConvertTo-Json $remainingReminders;
    }
    Set-Content $script:RemindersFile -Value $remainingContent;
}
Set-Alias -Name finish -Value Close-Reminder;
