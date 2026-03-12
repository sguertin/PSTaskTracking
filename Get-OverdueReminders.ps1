function Get-OverdueReminders {
    [cmdletBinding()]
    param()

    $today = Get-Date ((Get-Date).ToString("yyyy-MM-dd"));
    
    Get-ChildItem -Path (Get-ReminderFolder) -File | Where-Object LastWriteTime -LT $today;
}