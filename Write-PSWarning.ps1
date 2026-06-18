function Write-PSWarning {
    [CmdletBinding()]
    param(
        [string]$Text,
        [System.ConsoleColor]$PrefixForegroundColor = "Yellow",
        [string]$Command = $null
    )
    Write-PSHost -Text $Text -PrefixForegroundColor $PrefixForegroundColor `
        -ForegroundColor Yellow -Command $Command;
}
