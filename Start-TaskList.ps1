function Start-TaskList {
    <#
    .SYNOPSIS
    Starts the specified task list
    
    .DESCRIPTION
    Creates a copy of the specified task template and launches the nano text editor to begin filling it out
    
    .PARAMETER TaskList
    The task list to create, expects Morning, Midday, or EndOfDay
    
    .EXAMPLE
    Start-TaskList "Morning";
    
    Start-TaskList -TaskList "Midday";
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)][string]$TaskList
    )
    $taskTemplate = Join-Path (Get-TemplatesFolder) -ChildPath "$TaskList.md";
    $today = Get-Date;
    $timestamp = $today.ToString("yyyy-MM-dd");
    $tasksFolder = Get-TaskFolder;
    $newTaskFile = Join-Path $tasksFolder -ChildPath "$TaskList-$timestamp.md";
    if (Test-Path $newTaskFile) {
        Write-Error "$newTaskFile already exists!"
        return;
    }
    Copy-Item $taskTemplate -Destination $newTaskFile;    
    $dayOfWeek = $today.DayOfWeek.ToString().ToLower();    
    $dailyTasks = Join-Path (Get-TemplatesFolder) -ChildPath "$dayOfWeek.$TaskList.md";
    if (Test-Path $dailyTasks) {
        $content = Get-Content $newTaskFile;
        $content += "`n### $dayOfWeek Tasks `n"
        $content += Get-Content $dailyTasks -Raw;
        Set-Content $newTaskFile -Value $content
    }

    & nano $newTaskFile;
}
