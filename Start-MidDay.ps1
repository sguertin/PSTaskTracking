function Start-MidDay {
    <#
    .SYNOPSIS
    Start the midday task list
    
    .DESCRIPTION
    Creates a copy of the midday task template and launches the text editor to begin filling it out
    
    .EXAMPLE
    Start-MidDay;
    
    .NOTES
    Aliased as Midday
    #>
    [CmdletBinding()]
    param()
    
    Start-TaskList "midday";
}
Set-Alias -Name midday -Value Start-MidDay;