function Write-PSError {
    param(
        [string]$Text, 
        [ConsoleColor]$PrefixForegroundColor = "Yellow"
    )
    Write-PSHost -Text $Text -PrefixForegroundColor $PrefixForegroundColor -ForegroundColor Red;
}