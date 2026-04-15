function Edit-MorningTaskListTemplate {
    <#
    .SYNOPSIS
    Launches an editor to update the Morning Task list template.
    
    .EXAMPLE
    Edit-MorningTaskListTemplate
    #>
    [CmdletBinding()]
    param()
    Edit-TaskListTemplate -TaskList "Morning";
}
Set-Alias -Name MorningTemplate -Value Edit-MorningTaskListTemplate