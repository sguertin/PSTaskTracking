function Close-Reminder {
    <#
    .SYNOPSIS
    Closes a reminder
    
    .DESCRIPTION
    Closes a reminder by either piping the reminder file to this command or passing an Id and, 
    optionally a Date if the reminder is not from today, and it will be moved to closed.
    
    .PARAMETER File
    A piped reminder file
    
    .PARAMETER Id
    The Id for the file
    
    .PARAMETER Date
    The date for the reminder, only necessary if reminder is for a different day.
    
    .EXAMPLE
    
    Get-OverdueReminders | Close-Reminder;

    # Close reminder with id of 1
    Close-Reminder -Id 1;

    # Close reminder with an id of 2
    Close-Reminder 2;

    # Close reminder 3 from yesterday
    Close-Reminder -Id 3 -Date (Get-Date).AddDays(-1);
    
    .NOTES
    Aliased as finish
    #>    
    [CmdletBinding(DefaultParameterSetName = "Info")]
    param(
        [Parameter(Mandatory, ParameterSetName = "Pipe", ValueFromPipeline = $true)][System.IO.FileInfo]$File,
        [Parameter(Mandatory, Position = 1, ParameterSetName = "Info")][int]$Id,
        [Parameter(Position = 2, ParameterSetName = "Info")][DateTime]$Date = (Get-Date)
    )
    if ($null -eq $File) {
        $filePath = Get-ReminderFilePath -Id $Id -Date $Date;
        $File = Get-Item $filePath;        
    } 
    $resolution = (Read-Host "How was this reminder resolved?");    
    $content = Get-Content $filePath -Raw | ConvertFrom-Json;
    $content = @{
        Id         = $content.Id
        Reminder   = $content.Reminder
        Date       = $content.Date
        Resolution = $resolution
    } | ConvertTo-Json;
    Set-Content $filePath -Value $content;
    $closedFolder = Join-Path (Get-ReminderFolder) -ChildPath "closed";
    if ((Test-Path $closedFolder) -eq $false) {
        New-Item $closedFolder -ItemType Directory;
    }
    $closedItem = Join-Path $closedFolder -ChildPath $File.Name;
    $currentItem = $File.FullName;   
    Move-Item $currentItem -Destination $closedItem -Force | Out-Null;
}
Set-Alias finish -Value Close-Reminder