function Get-Reminders {
    <#
    .SYNOPSIS
    
    Retrieves all reminders for current day.
    
    .EXAMPLE
    Get-Reminders;    
    #> 
    [CmdletBinding()]
    param()
    $timestamp = (Get-Date).ToString($script:DateStamp);

    Get-ChildItem -Path $script:RemindersFolder | Where-Object Name -Match $timestamp | Get-Content -Raw | ConvertFrom-Json -AsHashtable -ErrorAction Stop;       
}
Set-Alias -Name today -Value Get-Reminders;
