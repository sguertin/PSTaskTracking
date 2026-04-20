function Initialize-PSTaskTracking {
    [CmdletBinding()]
    param()
    if (Test-EmptyString $env:LOCALAPPDATA) {
        $env:PSTT_AppData = Join-Path -Path $env:HOME -ChildPath ".local";
    } else {
        $env:PSTT_AppData = $env:LOCALAPPDATA;
    }
    $settingsFile = Get-TaskTrackerSettingsPath;
    if ((Test-Path $settingsFile) -eq $false) {
        New-Item $settingsFile -ItemType File -Value (ConvertTo-Json (Get-DefaultTaskTrackerSettings)) -Force;    
    }

    Sync-TaskTrackerSettings;

    $templatesFolder = Get-TemplatesFolder;
    if ((Test-Path $templatesFolder) -eq $false) {    
        New-Item $templatesFolder -ItemType Directory | Out-Null;
    }
    $morningTaskList = Join-Path $templatesFolder -ChildPath "Morning.md";
    $middayTaskList = Join-Path $templatesFolder -ChildPath "Midday.md";
    $endOfDayTaskList = Join-Path $templatesFolder -ChildPath "EndOfDay.md";
    if ((Test-Path $morningTaskList) -eq $false) {
        Write-Host "Creating default version of Morning Task list..."
        New-Item $morningTaskList -ItemType File -Value "## Morning Task List`n`n1. Do your morning tasks`n" | Out-Null;
        Write-Host "Created empty morning task list at:`n$morningTaskList`n You can edit the list with Edit-MorningTaskListTemplate.";
    } 
    if ((Test-Path $middayTaskList) -eq $false) {    
        Write-Host "Creating default version of Midday Task list..."
        New-Item $middayTaskList -ItemType File -Value "## Midday Task List`n`n1. Do your mid-day tasks`n";
        Write-Host "Created empty midday task list at:`n$middayTaskList`n You can edit the list with Edit-MiddayTaskListTemplate.";
    }
    if ((Test-Path $endOfDayTaskList) -eq $false) {    
        Write-Host "Creating default version of End Of Day Task list..."
        New-Item $endOfDayTaskList -ItemType File -Value "## End of Day Task List`n`n1. Do your end of day tasks`n" | Out-Null;
        Write-Host "Created empty end of day task list at:`n$endOfDayTaskList`n You can edit the list with Edit-EndOfDayTaskListTemplate.";
    }
    $remindersFolder = Get-RemindersFolder;
    $closedFolder = Join-Path $remindersFolder -ChildPath "closed";
    if (Test-Path $remindersFolder) {
        if ((Test-Path $closedFolder) -eq $false) {
            New-Item $closedFolder -ItemType Directory | Out-Null;
        } 
    } else {        
        New-Item $remindersFolder -ItemType Directory | Out-Null;        
        New-Item $closedFolder -ItemType Directory | Out-Null;
    }
}