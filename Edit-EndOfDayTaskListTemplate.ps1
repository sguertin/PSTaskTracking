function Edit-EndOfDayTaskListTemplate {
    <#
    .SYNOPSIS
    Launches an editor to update the EndOfDay Task list template.
    
    .EXAMPLE
    Edit-EndOfDayTaskListTemplate
    #>
    [CmdletBinding()]
    param()
    Edit-TaskListTemplate -TaskList "EndOfDay";
}
Set-Alias -Name EoDTemplate -Value Edit-EndOfDayTaskListTemplate;
Set-Alias -Name EndOfDayTemplate -Value Edit-EndOfDayTaskListTemplate;