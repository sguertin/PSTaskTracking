function New-EndOfDayReport {
    <#
    .SYNOPSIS
    Generate an end of day report for a given date and returns the path to the new report.
    
    .DESCRIPTION
    Concatenates together the contents of the morning, midday, and end of day task lists for the provided Date
    
    .PARAMETER Date
    The date for the report, defaults to today.
    
    .EXAMPLE
    # Generate today's report
    New-EndOfDayReport;

    # Generate a report for yesterday
    New-EndOfDayReport -Date (Get-Date).AddDays(-1);
    
    .NOTES
    Aliases are set for your convenience TaskReport, and Report
    #>
    [CmdletBinding()]
    param(
        [DateTime]$Date = (Get-Date)
    )
    
    $reportFile = Get-TaskList -TaskList Summary;
    if (Test-Path $reportFile) { 
        return Get-Item -Path $reportFile;
    }
    
    $timestamp = $Date.ToString("yyyy-MM-dd");
    $missingTaskList = $false;                
    $reportContent = "# Daily Task Report $timestamp`n`n";
    foreach ($taskList in @("Morning", "Midday", "EndOfDay")) {
        $taskFile = Get-TaskList -TaskList $taskList -Prompt;        
        if ($null -eq $taskFile) {
            Write-Error "No $taskList task list found!";
            $missingTaskList = $true;
        } else {
            $archivePath = Join-Path (Get-TaskFolder) -ChildPath "archive" `
                -AdditionalChildPath @($taskFile.Name);
            $reportContent += (Get-Content $taskFile -Raw);
            $reportContent += "`n";
            Move-Item $taskFile -Destination $archivePath;
        }
    }
    if ($missingTaskList) {
        Write-Error "Task files are missing, canceling report creation.";
        return $null;
    }
    Set-Content -Path $reportFile -Value $reportContent;
    
    return Get-Item -Path $reportFile;
}