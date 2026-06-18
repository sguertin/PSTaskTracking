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

    $today = Get-Date ((Get-Date).ToString($script:DateStamp));

    Get-ChildItem -Path $script:RemindersFolder -File | Get-Content -Raw `
    | ConvertFrom-Json -AsHashtable -ErrorAction Stop `
    | Where-Object Date -LT $today;
}
Set-Alias -Name overdue -Value Get-OverdueReminders;
