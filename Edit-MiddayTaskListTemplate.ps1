function Edit-MiddayTaskListTemplate {
    <#
    .SYNOPSIS
    Launches an editor to update the Midday Task list template.
    
    .EXAMPLE
    Edit-MiddayTaskListTemplate
    #>
    [CmdletBinding()]
    param()
    Edit-TaskListTemplate -TaskList "Midday";
}
Set-Alias -Name MiddayTemplate -Value Edit-MiddayTaskListTemplate;