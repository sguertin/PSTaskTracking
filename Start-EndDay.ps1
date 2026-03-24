function Start-EndOfDay {
    <#
    .SYNOPSIS
    Start the end of day task list
    
    .DESCRIPTION
    Creates a copy of the end of day task template and launches the nano text editor to begin filling it out
    
    .EXAMPLE
    Start-EndOfDay;
    
    .NOTES
    Aliased as EndDay, EOD, and EndOfDay
    #>
    [CmdletBinding()]
    param()
    
    Start-TaskList "endofday";
}
Set-Alias -Name EndDay -Value Start-EndOfDay;
Set-Alias -Name eod -Value Start-EndOfDay;
Set-Alias -Name EndOfDay -Value Start-EndOfDay;