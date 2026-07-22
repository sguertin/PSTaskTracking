#####
# #{ApplicationName}# Module V#{ModuleVersion}#
#####

Write-Verbose "Loading Functions ";
#####
# Functions
#
#{FunctionContent}#
#
# End of Functions
#####

#####
# Constants
#
Write-PSVerbose "Module Initialization Finished";
Write-PSVerbose "Initialize Constants...";
# Constant values
New-Variable -Name "ApplicationName" -Scope Script -Option Constant -Value "#{ApplicationName}#";
New-Variable -Name "#{ApplicationName}#Version" -Option Constant -Value "#{ModuleVersion}#";
New-Variable -Name "DateStamp" -Scope Script -Option Constant -Value "yyyy-MM-dd";
New-Variable -Name "DateTimeStamp" -Scope Script -Option Constant -Value "yyyy-MM-dd hh:mm";
New-Variable -Name "DateString" -Scope Script -Option Constant -Value "G";
# Directories
if ($IsWindows) {
    New-Variable -Name "TaskFolder" -Scope Script -Option Constant -Value `
    (Join-Path ($env:LOCALAPPDATA) -ChildPath $script:ApplicationName);
    New-Variable -Name "TempFolder" -Scope Script -Option Constant -Value $env:Temp;
} else {
    New-Variable -Name "TaskFolder" -Scope Script -Option Constant -Value `
    (Join-Path -Path $HOME -ChildPath ".local" -AdditionalChildPath @("share", $script:ApplicationName));
    New-Variable -Name "TempFolder" -Scope Script -Option Constant -Value (Join-Path "/" -ChildPath "tmp");
}
New-Variable -Name "TemplatesFolder" -Scope Script -Option Constant -Value (Join-Path $script:TaskFolder -ChildPath "templates");
New-Variable -Name "ArchiveFolder" -Scope Script -Option Constant -Value (Join-Path $script:TaskFolder -ChildPath "archive");
New-Variable -Name "ClosedFolder" -Scope Script -Option Constant -Value (Join-Path $script:TaskFolder -ChildPath "closed");
# Files
New-Variable -Name "RemindersFile" -Scope Script -Option Constant -Value (Join-Path $script:TaskFolder -ChildPath "reminders.json");
New-Variable -Name "SettingsFile" -Scope Script -Option Constant -Value (Join-Path $script:TaskFolder -ChildPath "settings.json");
New-Variable -Name "TempSettingsFile" -Scope Script -Option Constant -Value (Join-Path $script:TempFolder -ChildPath "PSTaskTracker.settings.json");

Write-PSVerbose "TaskFolder:`t`t $TaskFolder";
Write-PSVerbose "TemplatesFolder:`t`t $TemplatesFolder";
Write-PSVerbose "ArchiveFolder:`t`t $ArchiveFolder";
Write-PSVerbose "RemindersFile:`t`t $RemindersFile";
Write-PSVerbose "ClosedFolder:`t`t $ClosedFolder";
Write-PSVerbose "SettingsFile:`t`t $SettingsFile";
Write-PSVerbose "TempSettingsFile:`t`t $TempSettingsFile";

New-Variable -Name "DefaultSettings" -Scope Script -Option Constant -Value (Get-DefaultTaskTrackerSettings);
#
# End of Constants
#####

#####
# Module Initialization
#
Write-PSVerbose "Settings Initialization";

if (Test-Missing -Path $script:SettingsFile) {
    Reset-TaskTrackerSettings;
} else {
    Sync-TaskTrackerSettings;
}

Write-PSVerbose "Directory Initialization";
if (Test-Missing -Path $script:TemplatesFolder) {
    Write-PSVerbose "Creating Templates Folder: $TemplatesFolder";
    New-Item $script:TemplatesFolder -ItemType Directory | Out-Null;
}

if (Test-Missing -Path $script:ArchiveFolder) {
    Write-PSVerbose "Creating Archive Folder: $ArchiveFolder";
    New-Item $script:ArchiveFolder -ItemType Directory | Out-Null;
}

if (Test-Missing -Path $script:ClosedFolder) {
    Write-PSVerbose "Creating Closed Folder: $ClosedFolder";
    New-Item $script:ClosedFolder -ItemType Directory -Force | Out-Null;
}

Write-PSVerbose "Default files Initialization"
if (Test-Missing -Path (Join-Path $script:TemplatesFolder -ChildPath "Morning.md")) {
    Write-PSHost "Creating default version of Morning Task list..."
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "Morning.md") -ItemType File `
        -Value "## Morning Task List`n`n1. Do your morning tasks`n" | Out-Null;
    Write-PSHost "Created empty morning task list list. You can edit the list with Edit-MorningTaskListTemplate.";
}

if (Test-Missing -Path (Join-Path $script:TemplatesFolder -ChildPath "Midday.md")) {
    Write-PSHost "Creating default version of Midday Task list..."
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "Midday.md") -ItemType File `
        -Value "## Midday Task List`n`n1. Do your mid-day tasks`n" | Out-Null;
    Write-PSHost "Created empty midday task list. You can edit the list with Edit-MiddayTaskListTemplate.";
}

if (Test-Missing -Path (Join-Path $script:TemplatesFolder -ChildPath "EndOfDay.md")) {
    Write-PSHost "Creating default version of End Of Day Task list..."
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "EndOfDay.md") -ItemType File `
        -Value "## End of Day Task List`n`n1. Do your end of day tasks`n" | Out-Null;
    Write-PSHost "Created empty end of day task list. You can edit the list with Edit-EndOfDayTaskListTemplate.";
}

if (Test-Missing -Path (Join-Path $script:TemplatesFolder -ChildPath "WorkLog.md")) {
    Write-PSHost "Creating base work log task...";
    New-Item (Join-Path $script:TemplatesFolder -ChildPath "WorkLog.md") -ItemType File `
        -Value "## Work Log #{Name}# - #{DateTimeStamp}#`n`n#{Ticket}##{Time}#`n`n" | Out-Null;
    Write-PSHost "Created base work log task, you can edit the task with the command 'Edit-WorkLog'. ";
}

if (Test-Missing -Path $script:RemindersFile) {
    Write-PSVerbose "Creating Reminders File: $RemindersFile";
    New-Item $script:RemindersFile -ItemType File -Value "[]" | Out-Null;
}
#
# End of Module Initialization
#####
