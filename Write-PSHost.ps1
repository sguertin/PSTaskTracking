function Write-PSHost { 
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Text,
        [ConsoleColor]$ForegroundColor = "Gray",
        [ConsoleColor]$PrefixForegroundColor = "Yellow"
    )
    $timestamp = (Get-Date).ToString($script:DateTimeStamp);
    Write-PSHost "[$timestamp][$PSTaskTrackerName] " -ForegroundColor $PrefixForegroundColor -NoNewLine;

    Write-PSHost $Text -ForegroundColor $ForegroundColor;
}