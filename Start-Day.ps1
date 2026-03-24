function Start-Day {
    <#
    .SYNOPSIS
    Start the morning task list
    
    .DESCRIPTION
    Creates a copy of the morning task template and launches the nano text editor to begin filling it out
    
    .EXAMPLE
    Start-Day;
    
    .NOTES
    Aliased as morning
    #>
    [CmdletBinding()]
    param()
    
    Start-TaskList "morning";
}
Set-Alias -Name morning -Value Start-Day;