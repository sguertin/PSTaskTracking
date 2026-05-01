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
    $now = Get-Date;
    $uhOhCounter = 0;
    if (Test-Path (Get-TaskList -TaskList Summary)) {
        return $true;
    }    
    if (($now.Hour) -ge $script:Settings.Morning.Hour -and ($now.Minute) -ge $script:Settings.Morning.Minute) {
        if ((Test-TaskList -TaskList Morning -Date $now) -eq $false) {
            $uhOhCounter++;
        }
    }
    if (($now.Hour) -ge $script:Settings.Midday.Hour -and ($now.Minute) -ge $script:Settings.Midday.Minute) {
        if ((Test-TaskList -TaskList Midday -Date $now) -eq $false) {
            $uhOhCounter++;
        }
    }
    if (($now.Hour) -ge $script:Settings.EndOfDay.Hour -and ($now.Minute) -ge $script:Settings.EndOfDay.Minute) {
        if ((Test-TaskList -TaskList EndOfDay -Date $now) -eq $false) {
            $uhOhCounter++;
        }
    }
    if ((($now.Hour) -ge $script:Settings.Report.Hour) -and ($now.Minute) -ge $script:Settings.Report.Minute) {
        $uhOhCounter++;
        Write-Host "Gotta compile your end of day report!" -ForegroundColor; 
    }
    if ($uhOhCounter -gt 1) {
        Write-Host "YOU NEED TO GET YOUR TASKS TOGETHER NOW" -ForegroundColor Red;
    }
    return ($uhOhCounter -eq 0);
}
Set-Alias -Name TaskStatus -Value Test-TaskLists;