function Test-TaskLists {
    $tasksFolder = Get-TaskFolder;
    $timestamp = (Get-Date).ToString("yyyy-MM-dd")
    $morningTaskFile = "$tasksFolder\Morning-$timestamp.tasks"
    $midDayTaskFile = "$tasksFolder\Midday-$timestamp.tasks"
    $endOfDayTaskFile = "$tasksFolder\EndOfDay-$timestamp.tasks"
    $summaryReport = "$tasksFolder\Summary-$timestamp.md";
    $uhOhCounter = 0;
    $now = Get-Date;
    if ((($now.Hour) -ge 15) -and ($now.Minute) -ge 50) {
        if ((Test-Path $summaryReport) -eq $false) {
            $uhOhCounter += 1;      
            Write-Warning "Gotta compile your end of day report!";
        }
    }
    if ((Test-Path $summaryReport) -eq $false) {
        if ((Test-Path $morningTaskFile) -eq $false) { 
            $uhOhCounter += 1;      
            Write-Warning "Gotta start your morning tasks!"
        }
        
    

        if (($now.Hour) -ge 12) {
            if ((Test-Path $midDayTaskFile) -eq $false) {
                $uhOhCounter += 1;      
                Write-Warning "Gotta start your midday tasks!";
            }
        }

        if (($now.Hour) -ge 15) {
            if ((Test-Path $endOfDayTaskFile) -eq $false) {
                $uhOhCounter += 1;      
                Write-Warning "Gotta start your end of day tasks!";
            }
        }
    }
    
    if ($uhOhCounter -gt 1) {
        Write-Error "YOU NEED TO GET YOUR TASKS TOGETHER NOW";
    }
}
Set-Alias -Name TaskStatus -Value Test-TaskLists;