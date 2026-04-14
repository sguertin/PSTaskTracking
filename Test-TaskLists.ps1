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
    $now = Get-Date;
    $timestamp = ($now).ToString("yyyy-MM-dd")
    $morningTaskFile = Join-Path $tasksFolder "Morning-$timestamp.md"
    $midDayTaskFile = Join-Path $tasksFolder "Midday-$timestamp.md"
    $endOfDayTaskFile = Join-Path $tasksFolder "EndOfDay-$timestamp.md"
    $summaryReport = Join-Path $tasksFolder "Summary-$timestamp.md";
    
    # Time frames for each task list
    $morningHour = $env:PSTT_MorningHour;
    $morningMinute = $env:PSTT_MorningMinute
    $middayHour = $env:PSTT_MiddayHour;
    $middayMinute = $env:PSTT_MiddayMinute;
    $endOfDayHour = $env:PSTT_EndOfDayHour;
    $endOfDayMinute = $env:PSTT_EndOfDayMinute;
    $closeDayHour = $env:PSTT_CloseDayHour;
    $closeDayMinute = $env:PSTT_CloseDayMinute;
    # end of time frames
    $uhOhCounter = 0;
    if ((($now.Hour) -ge $closeDayHour) -and ($now.Minute) -ge $closeDayMinute) {
        if ((Test-Path $summaryReport) -eq $false) {
            $uhOhCounter += 1;
            Write-Warning "Gotta compile your end of day report!";
        }
    }
    if ((Test-Path $summaryReport) -eq $false) {
        if (($now.Hour) -ge $morningHour -and ($now.Minute) -ge $morningMinute) {
            if ((Test-Path $morningTaskFile) -eq $false) {
                $uhOhCounter += 1;
                Write-Warning "Gotta start your morning tasks!"
            }
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