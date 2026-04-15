function Edit-DayTaskList {
    [CmdletBinding()]
    param(
        [ValidateSet("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")]
        [Parameter(Mandatory, Position = 1)][string]$DayOfWeek,
        [ValidateSet("Morning", "Midday", "EndOfDay")]
        [Parameter(Mandatory, Position = 2)][string]$TimeOfDay
    )
    $fileName = "$DayOfWeek.$TimeOfDay.md";
    $taskListPath = Join-Path -Path (Get-TaskFolder) -ChildPath $fileName;
    if ((Test-Path $taskListPath) -eq $false) {
        Write-Host "Creating $fileName..."
        New-Item $taskListPath -ItemType File;
    }
    & $env:PSTT_Editor $taskListPath;
}