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
    [int]$uhOhCounter = 0;
    if (Test-Path (Get-TaskList -TaskList Summary)) {
        return;
    }    
    if (($now.Hour) -ge $Settings.Morning.Hour -and ($now.Minute) -ge $Settings.Morning.Minute) {
        if ($null -eq (Get-TaskList -TaskList Morning)) {
            $uhOhCounter++;
            Write-Warning "Gotta start your morning tasks!"
        }
    }
    if (($now.Hour) -ge $Settings.Midday.Hour -and ($now.Minute) -ge $Settings.Midday.Minute) {
        if ($null -eq (Get-TaskList -TaskList Midday)) {
            $uhOhCounter++;
            Write-Warning "Gotta start your midday tasks!";
        }
    }
    if (($now.Hour) -ge $Settings.EndOfDay.Hour -and ($now.Minute) -ge $Settings.EndOfDay.Minute) {
        if ($null -eq (Get-TaskList -TaskList EndOfDay)) {
            $uhOhCounter++;
            Write-Warning "Gotta start your end of day tasks!";
        }
    }
    if ((($now.Hour) -ge $Settings.Report.Hour) -and ($now.Minute) -ge $Settings.Report.Minute) {
        $uhOhCounter++;
        Write-Warning "Gotta compile your end of day report!";
    }
    if ($uhOhCounter -gt 1) {
        Write-Error "YOU NEED TO GET YOUR TASKS TOGETHER NOW";
    }
}
Set-Alias -Name TaskStatus -Value Test-TaskLists;