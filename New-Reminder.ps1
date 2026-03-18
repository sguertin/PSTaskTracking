function New-Reminder {
    <#
    .SYNOPSIS
    Creates a reminder 
    
    .DESCRIPTION
    Creates a new reminder file in the reminders folder
    
    .PARAMETER Reminder
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
        [Parameter(Mandatory, Position = 1)][string]$Reminder,
        [Parameter(Mandatory, Position = 2)][DateTime]$Date,    
        [switch]$Day
    )
    $reminderDirectory = Get-ReminderFolder;
    $timestamp = $Date.ToString("yyyy-MM-dd")
    if ($Day -eq $true) {
        $Date = Get-Date $timestamp
    }
    
    $id = 1;
    $content = @{
        Id         = $id
        Reminder   = $Reminder
        Date       = $Date
        Resolution = $null
    };
    
    $filePath = Join-Path -Path $reminderDirectory -ChildPath "reminder-$timestamp.$id.json";    
    while (Test-Path -Path $filePath) {
        $id += 1;        
        $content.Id = $id
        $filePath = Join-Path -Path $reminderDirectory -ChildPath "reminder-$timestamp.$id.json";        
    }
    $content = $content | ConvertTo-Json;
    New-Item -Path $filePath -ItemType File -Value $content -Force | Out-Null;
}
Set-Alias -Name reminder -Value New-Reminder;
