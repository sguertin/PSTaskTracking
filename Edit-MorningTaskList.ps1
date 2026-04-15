function Edit-MorningTaskList {
    [CmdletBinding()]
    param()
    Edit-TaskList -TaskList "Morning";
}
Set-Alias -Name MorningTemplate -Value Edit-MorningTaskList