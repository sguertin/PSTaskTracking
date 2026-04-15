function Edit-MiddayTaskList {
    [CmdletBinding()]
    param()
    Edit-TaskList -TaskList "Midday";
}
Set-Alias -Name MiddayTemplate -Value Edit-MiddayTaskList;