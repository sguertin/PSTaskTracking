function ConvertTo-ReminderString {
    [CmdletBinding()]
    param(
        [Object]$Reminder
    )
    return "Id: " + $Reminder.Id + ": [" + $Reminder.Date.ToString($script:DateString) + "]" + $reminder.Text;
}