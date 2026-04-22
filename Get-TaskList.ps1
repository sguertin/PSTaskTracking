function Get-TaskList {
    <#
    .SYNOPSIS
    Returns the path to a task list file for a given date

    .DESCRIPTION
    Provided a task list name and a date, defaulting to today, if the task list is not found, user will be prompted to create it. If the user declines
    to create the task list, the function will return null otherwise it will return the path to the task list. Function still returns the path to the
    summary report for internal reasons.

    .PARAMETER Date
    The date of the task list.

    .PARAMETER TaskList
    The task list to retrieve, expected values are Morning, Midday, EndOfDay, or Summary

    .EXAMPLE
    # Get Morning's task list
    Get-TaskList Morning

    # Get last week's midday report
    Get-TaskList -TaskList Midday -Date (Get-Date).AddDays(-7);

    # Get yesterday's end of day report.
    Get-TaskList EndOfDay (Get-Date).AddDays(-1)

    # Get summary
    Get-TaskList Summary;

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [ValidateSet("Morning", "Midday", "EndOfDay", "Summary")]
        [Parameter(Mandatory, Position = 1)][string]$TaskList,
        [Parameter(Position = 2)][DateTime]$Date = (Get-Date),
        [switch]$Prompt

    )
    $timestamp = $Date.ToString("yyyy-MM-dd");
    $taskFile = Join-Path (Get-TaskFolder) -ChildPath "$TaskList-$timestamp.md";
    $archiveFolder = Join-Path (Get-TaskFolder) -ChildPath "archive";
    $archivedFile = Join-Path $archiveFolder -ChildPath "$TaskList-$timestamp.md";
    if (Test-Path $archivedFile) {
        return Get-Item -Path $archivedFile;
    }
    if ((Test-Path $taskFile) -eq $false) {
        if ($TaskList -eq "Summary") {
            Write-Verbose "Summary report for $timestamp cannot be found."
            return $taskFile;
        }
        if ($Prompt) {
            Write-Warning "No $TaskList task list found, do you want to create one now?"
            $response = Read-Host "[Y]es/[N]o:";
            if ($response.ToUpper().StartsWith("Y")) {
                Start-TaskList -TaskList $TaskList -Date $Date;
            }
        }
        return $null;
    }
    return Get-Item -Path $taskFile;
}