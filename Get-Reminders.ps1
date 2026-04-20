function Get-Reminders {
    <#
    .SYNOPSIS
    
    Retrieves all reminders for current day.
    
    .EXAMPLE
    Get-Reminders;    
    #> 
    [CmdletBinding()]
    param()
    $timestamp = (Get-Date).ToString("yyyy-MM-dd");

    Get-ChildItem -Path (Get-RemindersFolder) | Where-Object Name -Match $timestamp | Get-Content -Raw | ConvertFrom-Json -ErrorAction Stop;       
}
Set-Alias -Name today -Value Get-Reminders;
