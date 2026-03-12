function Start-TaskList {
    param(
        [string]$TaskList
    )
    $tasksFolder = Get-TaskFolder;
    $taskTemplate = "$tasksFolder\templates\$TaskList.tasks";
    $today = Get-Date;
    $timestamp = $today.ToString("yyyy-MM-dd");
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
