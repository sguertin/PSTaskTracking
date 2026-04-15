function Start-Morning {
    <#
    .SYNOPSIS
    Start the morning task list
    
    .DESCRIPTION
    Creates a copy of the morning task template and launches the text editor to begin filling it out
    
    .EXAMPLE
    Start-Morning;
    
    .NOTES
    Aliased as morning
    #>
    [CmdletBinding()]
    param(
        [datetime]$Date = (Get-Date)
    )
    
    Start-TaskList -TaskList "Morning" -Date $Date;
}
Set-Alias -Name morning -Value Start-Morning;
