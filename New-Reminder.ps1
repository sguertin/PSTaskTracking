function New-Reminder {
    <#
    .SYNOPSIS
    Creates a reminder

    .DESCRIPTION
    Creates a new reminder file in the reminders folder

    .PARAMETER Text
    The text of the reminder i.e. what you want to be reminded to do.

    .PARAMETER Date
    The date/time that you want to start being reminded for.

    .PARAMETER Day
    If passed, reminder will be set to midnight of the date provided

    .EXAMPLE
    New-Reminder "Remember to review your reminders!";

    .NOTES
    Aliased as reminder
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)][string]$Text,
        [Parameter(Position = 2)][DateTime]$Date = (Get-Date),
        [int]$Days = 0,
        [int]$Hours = 0,
        [int]$Minutes = 0,
        [switch]$Day
    )

    $timestamp = $Date.ToString($script:DateStamp)
    if ($Day -eq $true) {
        $Date = Get-Date -Date $timestamp
    }
    $Date = $Date.AddDays($Days).AddHours($Hours).AddMinutes($Minutes);
    if (Test-Path $script:RemindersFile) {
        $reminders = Get-Content $script:RemindersFile | ConvertFrom-Json;
    } else {
        New-Item $script:RemindersFile -ItemType File;
        $reminders = @()
    }
    $id = 1;
    foreach($reminder in $reminders) {
        if ($reminder.Id -gt $id) {
            $id = $reminder.Id + 1;
        }
    }
    $reminders += @{
        Id         = $id
        Text       = $Text
        Date       = $Date
        Resolution = "None"
    };
    $content = ConvertTo-Json $reminders;
    if ($reminders.Length -eq 1) {
        $content = "[$content]";
    }
    Set-Content $script:RemindersFile -Value $content;
}
Set-Alias -Name reminder -Value New-Reminder;
