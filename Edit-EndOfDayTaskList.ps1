function Edit-EndOfDayTaskList {
    [CmdletBinding()]
    param()
    Edit-TaskList -TaskList "EndOfDay";
}
Set-Alias -Name EoDTemplate -Value Edit-EndOfDayTaskList;
Set-Alias -Name EndOfDayTemplate -Value Edit-EndOfDayTaskList;