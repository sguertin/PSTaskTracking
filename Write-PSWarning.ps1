function Write-PSWarning {
    param(
        [string]$Text, 
        [System.ConsoleColor]$PrefixForegroundColor = "Yellow"
    )
    Write-PSHost -Text $Text -PrefixForegroundColor $PrefixForegroundColor -ForegroundColor Yellow;
}