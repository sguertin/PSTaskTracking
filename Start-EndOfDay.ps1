function Start-EndOfDay {
    <#
    .SYNOPSIS
    Start the end of day task list
    
    .DESCRIPTION
    Creates a copy of the end of day task template and launches the text editor to begin filling it out
    
    .EXAMPLE
    Start-EndOfDay;
    
    .NOTES
    Aliased as EoD and EndOfDay
    #>
    [CmdletBinding()]
    param(
        [datetime]$Date = (Get-Date)
    )
    
    Start-TaskList -TaskList "EndOfDay" -Date $Date;
}
Set-Alias -Name EoD -Value Start-EndOfDay;
Set-Alias -Name EndOfDay -Value Start-EndOfDay;