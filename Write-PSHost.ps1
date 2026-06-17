function Write-PSHost { 
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Text,
        [ConsoleColor]$ForegroundColor = "Gray",
        [ConsoleColor]$PrefixForegroundColor = "Yellow"
    )
    $timestamp = (Get-Date).ToString($script:DateTimeStamp);
    Write-Host "[$timestamp][$ApplicationName] " -ForegroundColor $PrefixForegroundColor -NoNewLine;

    Write-Host $Text -ForegroundColor $ForegroundColor;
}