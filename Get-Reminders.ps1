function Get-Reminders {
    <#
        Retrieves all reminders for today.
    #>    
    [CmdletBinding()]
    param()
    $timestamp = (Get-Date).ToString("yyyy-MM-dd");

    Get-ChildItem -Path (Get-ReminderFolder) | Where-Object Name -Match $timestamp | Get-Content -Raw | ConvertFrom-Json -ErrorAction Stop;       
}
Set-Alias today -Value Get-Reminders;
