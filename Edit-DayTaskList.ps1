function Edit-DayTaskList {
    <#
    .SYNOPSIS
    Creates or Edits an existing Day TaskList.
    
    .DESCRIPTION
    Creates a Day Task List for the specified DayOfWeek and TimeOfDay specified and then launches the text editor. 
    If a task list already exists for that day, the text editor is simply launched.
    
    .PARAMETER DayOfWeek
    The day of the week for the task list (Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday)
    
    .PARAMETER TimeOfDay
    The time of day, Morning, Midday, or EndOfDay, that this task list will be appended.
    
    .EXAMPLE
    Edit-DayTaskList -DayOfWeek Sunday -TimeOfDay Midday;

    Edit-DayTaskList Friday EndOfDay;
    #>
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
    Invoke-TextEditor -Path $taskListPath;
}