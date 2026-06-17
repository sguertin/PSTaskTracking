function Test-PSTaskTrackerStatus {
    [CmdletBinding()]
    param()

    if ($script:Settings.EnableTaskLists -eq $true) {
        Test-TaskLists;
    }

    if ($script:Settings.EnableReminders -eq $true) {
        Test-Reminders -SilentAllClear;
    }
}