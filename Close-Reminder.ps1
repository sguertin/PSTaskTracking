function Close-Reminder {
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