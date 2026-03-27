function Get-OverdueReminders {
    <#
    .SYNOPSIS
    Retrieves all overdue reminders
    
    .DESCRIPTION
    Retrieves all active reminders that are from older than today.
    
    .EXAMPLE
    
    Get-OverdueReminders;
    
    .NOTES
    Aliased as overdue
    #>
    [CmdletBinding()]
    param()

    $today = Get-Date ((Get-Date).ToString("yyyy-MM-dd"));
    
    Get-ChildItem -Path (Get-ReminderFolder) -File | Get-Content -Raw | ConvertFrom-Json -ErrorAction Stop | Where-Object Date -LT $today
}
Set-Alias overdue -Value Get-OverdueReminders;