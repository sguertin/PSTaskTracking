function Get-ReminderFolder {
    return Join-Path -Path (Get-TaskFolder) -ChildPath "reminders";
}