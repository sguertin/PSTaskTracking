#####
# PSTaskTracking Module V#{ModuleVersion}#
#
## Constants
$script:ApplicationName = "PSTaskTracking";
$PSTaskTrackingVersion = "#{ModuleVersion}#";

$script:Version = $PSTaskTrackingVersion;
$script:DateStamp = "yyyy-MM-dd";
$script:DateTimeStamp = "yyyy-MM-dd hh:mm";
$script:DateString = "G";

if ([string]::IsNullOrEmpty($env:LOCALAPPDATA)) {
    $script:TaskFolder = Join-Path -Path $env:HOME `
        -ChildPath ".local" -AdditionalChildPath @($script:ApplicationName);
} else {
    $script:TaskFolder = Join-Path ($env:LOCALAPPDATA) -ChildPath $script:ApplicationName;
}
$script:TemplatesFolder = Join-Path $script:TaskFolder -ChildPath "templates";
$script:ArchiveFolder = Join-Path $script:TaskFolder -ChildPath "archive";
$script:RemindersFolder = Join-Path $script:TaskFolder -ChildPath "reminders";
$script:ClosedFolder = Join-Path $script:RemindersFolder -ChildPath "closed";
$script:SettingsFile = Join-Path $script:TaskFolder -ChildPath "settings.json";
$script:TempSettingsFile = Join-Path $env:TEMP -ChildPath "settings.json";

### End of Constants

#{ModuleContent}#

### Module Initialization

$script:DefaultSettings = Get-DefaultTaskTrackerSettings;
if (Test-Missing $script:SettingsFile) {
    $script:Settings = Reset-TaskTrackerSettings;
} else {
    $script:Settings = Sync-TaskTrackerSettings;
}

if (Test-Missing $script:TemplatesFolder) {    
    New-Item $script:TemplatesFolder -ItemType Directory | Out-Null;
}

if (Test-Missing $script:ArchiveFolder) {    
    New-Item $script:ArchiveFolder -ItemType Directory | Out-Null;
}

if (Test-Missing (Join-Path $script:TemplatesFolder -ChildPath "Morning.md")) {
    Write-PSHost "Creating default version of Morning Task list..."
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "Morning.md") -ItemType File `
        -Value "## Morning Task List`n`n1. Do your morning tasks`n" | Out-Null;
    Write-PSHost "Created empty morning task list list. You can edit the list with Edit-MorningTaskListTemplate.";
} 

if (Test-Missing (Join-Path $script:TemplatesFolder -ChildPath "Midday.md")) {    
    Write-PSHost "Creating default version of Midday Task list..."
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "Midday.md") -ItemType File `
        -Value "## Midday Task List`n`n1. Do your mid-day tasks`n" | Out-Null;
    Write-PSHost "Created empty midday task list. You can edit the list with Edit-MiddayTaskListTemplate.";
}

if (Test-Missing (Join-Path $script:TemplatesFolder -ChildPath "EndOfDay.md")) {    
    Write-PSHost "Creating default version of End Of Day Task list..."
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "EndOfDay.md") -ItemType File `
        -Value "## End of Day Task List`n`n1. Do your end of day tasks`n" | Out-Null;
    Write-PSHost "Created empty end of day task list. You can edit the list with Edit-EndOfDayTaskListTemplate.";
}

if (Test-Missing (Join-Path $script:TemplatesFolder -ChildPath "WorkLog.md")) {
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "WorkLog.md") -ItemType File `
        -Value "## Work Log #{Name}# - #{DateTimeStamp}#`n`n#{Ticket}##{Time}#`n`n";
    Write-Host "Created base work log task, you can edit the task with the command 'Edit-WorkLog'. ";
}

if (Test-Missing $script:RemindersFolder) {
    New-Item $script:RemindersFolder -ItemType Directory | Out-Null;        
    New-Item $script:ClosedFolder -ItemType Directory | Out-Null;    
} elseif (Test-Missing $script:ClosedFolder) {
    New-Item $script:ClosedFolder -ItemType Directory -Force | Out-Null;
}

