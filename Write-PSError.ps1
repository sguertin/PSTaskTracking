function Write-PSError {
    [CmdletBinding()]
    param(
        [string]$Text,
        [ConsoleColor]$PrefixForegroundColor = "Yellow",
        [string]$Command = $null
    )
    Write-PSHost -Text $Text -PrefixForegroundColor $PrefixForegroundColor `
        -ForegroundColor Red -Command $Command;
}
