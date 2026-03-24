function Initialize-PSTaskTracking {
    <#
    .SYNOPSIS
    Initialize the PSTaskTracking directories and files
    
    .DESCRIPTION
    Creates a folder structure under the user profile directory, in a folder called Daily Tasks. It then creates 
    two subdirectories 'templates' and 'reminders'. It also creates empty files for morning, noon, and end of day tasks.
    These are left to be filled out with your tasks as needed.
    
    .EXAMPLE
    Initialize-PSTaskTracking;
    
    #>
    [CmdletBinding()]
    param()

    Write-Host "Initializing task tracking..."
    $taskFolder = Get-TaskFolder;
    if (Test-Path $taskFolder) {
        Write-Warning "$taskFolder already exists.";
    } else {
        New-Item $taskFolder -ItemType Directory -Force | Out-Null;
    }
    $templateFolder = Get-TemplatesFolder;
    if (Test-Path $templateFolder) {
        Write-Warning "$templateFolder already exists.";
    } else {
        New-Item $templateFolder -ItemType Directory | Out-Null;
    }
    $morningTaskList = Join-Path $templateFolder -ChildPath "morning.md";
    $middayTaskList = Join-Path $templateFolder -ChildPath "midday.md";
    $endOfDayTaskList = Join-Path $templateFolder -ChildPath "endofday.md";
    if (Test-Path $morningTaskList) {
        Write-Host "$morningTaskList already exists."
    } else {
        Write-Host "Creating default version of $morningTaskList..."
        New-Item $morningTaskList -ItemType File -Value "## Morning Task List`n`n1. Do your morning tasks"
    }
    if (Test-Path $middayTaskList) {
        Write-Host "$middayTaskList already exists."
    } else {
        Write-Host "Creating default version of $middayTaskList..."
        New-Item $middayTaskList -ItemType File -Value "## Midday Task List`n`n1. Do your mid-day tasks"
    }
    if (Test-Path $endOfDayTaskList) {
        Write-Host "$endOfDayTaskList already exists."
    } else {
        Write-Host "Creating default version of $endOfDayTaskList..."
        New-Item $endOfDayTaskList -ItemType File -Value "## End of Day Task List`n`n1. Do your end of day tasks"
    }
    $remindersFolder = Join-Path $taskFolder -ChildPath "reminders";
    $closedFolder = Join-Path $remindersFolder -ChildPath "closed";
    if (Test-Path $remindersFolder) {
        Write-Host "$remindersFolder already exists...";
        if ((Test-Path $closedFolder) -eq $false) {
            New-Item $closedFolder -ItemType Directory | Out-Null;
        }
    } else {        
        New-Item $remindersFolder -ItemType Directory | Out-Null;        
        New-Item $closedFolder -ItemType Directory | Out-Null;
    }

}