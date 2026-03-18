function Test-TaskLists {
    <#
    .SYNOPSIS
    Checks if tasks need to be done.
    
    .DESCRIPTION
    Checks to see if files have been created for each of the morning, midday, and end of day task lists for today 
    based on the current time of day. 
    
    .EXAMPLE
    Test-TaskLists;
    
    #>
    [CmdletBinding()]
    param()
    $tasksFolder = Get-TaskFolder;
    $timestamp = (Get-Date).ToString("yyyy-MM-dd")
    $morningTaskFile = "$tasksFolder\Morning-$timestamp.tasks"
    $midDayTaskFile = "$tasksFolder\Midday-$timestamp.tasks"
    $endOfDayTaskFile = "$tasksFolder\EndOfDay-$timestamp.tasks"
    $summaryReport = "$tasksFolder\Summary-$timestamp.md";
    $now = Get-Date;
    # Time frames for each task list
    $middayHour = 12;
    $middayMinute = 0;
    $endOfDayHour = 15;
    $endOfDayMinute = 0;
    $closeDayHour = 15;
    $closeDayMinute = 50;
    # end of time frames
    $uhOhCounter = 0;
    if ((($now.Hour) -ge $closeDayHour) -and ($now.Minute) -ge $closeDayMinute) {
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
        
    

        if (($now.Hour) -ge $middayHour -and ($now.Minute) -ge $middayMinute) {
            if ((Test-Path $midDayTaskFile) -eq $false) {
                $uhOhCounter += 1;      
                Write-Warning "Gotta start your midday tasks!";
            }
        }

        if (($now.Hour) -ge $endOfDayHour -and ($now.Minute) -ge $endOfDayMinute) {
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