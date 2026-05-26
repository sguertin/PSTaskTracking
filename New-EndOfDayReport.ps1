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
    $reportFile = Get-TaskList -TaskList Summary -Date $Date;

    if (Test-Path $reportFile) {
        return Get-Item -Path $reportFile;
    }

    $timestamp = $Date.ToString($script:DateStamp);
    $workLogs = Get-WorkDayLogs -Date $Date;
    if ($null -eq $workLogs) {
        Write-PSError "No worklogs found for $Date!";
        return;
    }
    $reportContent = "# Daily Task Report $timestamp`n`n";
    foreach($workLog in $workLogs) {
        $taskContent = (Get-Content $workLog.Path -Raw);
        if ($taskContent.EndsWith("`n") -eq $false) {
            $taskContent += "`n";
        }
        $reportContent += $taskContent;
        Move-Item $workLog.Path -Destination $workLog.ArchivePath;
    }

    Set-Content -Path $reportFile -Value $reportContent;

    return Get-Item -Path $reportFile;
}