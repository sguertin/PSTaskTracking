$PSTaskTrackerName = "PSTaskTracking";
#{ModuleContent}#

# Constants
$script:DateStamp = "yyyy-MM-dd";
$script:DateTimeStamp = "yyyy-MM-dd hh:mm";
$script:DateString = "G";

if ([string]::IsNullOrEmpty($env:LOCALAPPDATA)) {
    $script:TaskFolder = Join-Path -Path $env:HOME `
        -ChildPath ".local" -AdditionalChildPath @($PSTaskTrackerName);
} else {
    $script:TaskFolder = Join-Path ($env:LOCALAPPDATA) -ChildPath $PSTaskTrackerName;
}
$script:TemplatesFolder = Join-Path $script:TaskFolder -ChildPath "templates";
$script:ArchiveFolder = Join-Path $script:TaskFolder -ChildPath "archive";
$script:RemindersFolder = Join-Path $script:TaskFolder -ChildPath "reminders";
$script:ClosedFolder = Join-Path $script:RemindersFolder -ChildPath "closed";
$script:SettingsFile = Join-Path $script:TaskFolder -ChildPath "settings.json";

if (Test-Path $script:SettingsFile) {
    $script:Settings = Get-TaskTrackerSettings;
} else {
    $script:Settings = Get-DefaultTaskTrackerSettings;
    New-Item $script:SettingsFile -ItemType File `
        -Value (ConvertTo-Json $script:Settings) -Force | Out-Null;
}
if ((Test-Path $script:TemplatesFolder) -eq $false) {    
    New-Item $script:TemplatesFolder -ItemType Directory | Out-Null;
}

if ((Test-Path $script:ArchiveFolder) -eq $false) {    
    New-Item $script:ArchiveFolder -ItemType Directory | Out-Null;
}

if ((Test-Path (Join-Path $script:TemplatesFolder -ChildPath "Morning.md")) -eq $false) {
    Write-PSHost "Creating default version of Morning Task list..."
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "Morning.md") -ItemType File `
        -Value "## Morning Task List`n`n1. Do your morning tasks`n" | Out-Null;
    Write-PSHost "Created empty morning task list list. You can edit the list with Edit-MorningTaskListTemplate.";
} 

if ((Test-Path (Join-Path $script:TemplatesFolder -ChildPath "Midday.md")) -eq $false) {    
    Write-PSHost "Creating default version of Midday Task list..."
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "Midday.md") -ItemType File `
        -Value "## Midday Task List`n`n1. Do your mid-day tasks`n" | Out-Null;
    Write-PSHost "Created empty midday task list. You can edit the list with Edit-MiddayTaskListTemplate.";
}

if ((Test-Path (Join-Path $script:TemplatesFolder -ChildPath "EndOfDay.md")) -eq $false) {    
    Write-PSHost "Creating default version of End Of Day Task list..."
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "EndOfDay.md") -ItemType File `
        -Value "## End of Day Task List`n`n1. Do your end of day tasks`n" | Out-Null;
    Write-PSHost "Created empty end of day task list. You can edit the list with Edit-EndOfDayTaskListTemplate.";
}

if (Test-Path $script:RemindersFolder) {
    if ((Test-Path $script:ClosedFolder) -eq $false) {
        New-Item $script:ClosedFolder -ItemType Directory -Force | Out-Null;
    } 
} else {        
    New-Item $script:RemindersFolder -ItemType Directory | Out-Null;        
    New-Item $script:ClosedFolder -ItemType Directory | Out-Null;
}