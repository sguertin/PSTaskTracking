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
    $taskTemplate = Join-Path (Get-TemplatesFolder) -ChildPath "$TaskList.tasks";
    $today = Get-Date;
    $timestamp = $today.ToString("yyyy-MM-dd");
    $tasksFolder = Get-TaskFolder;
    $newTaskFile = "$tasksFolder\$TaskList-$timestamp.tasks";
    if (Test-Path $newTaskFile) {
        Write-Error "$newTaskFile already exists!"
        return;
    }
    $dayOfWeek = $today.DayOfWeek;
    $dailyTasks = "$tasksFolder\templates\$dayOfWeek.$TaskList.tasks"
    Copy-Item $taskTemplate -Destination $newTaskFile;

    if (Test-Path $dailyTasks) {
        $content = Get-Content $newTaskFile;
        $content += "`n"
        $content += "$dayOfWeek Tasks `n"
        $content += Get-Content $dailyTasks -Raw;
        Set-Content $newTaskFile -Value $content
    }

    & nano $newTaskFile;
}
