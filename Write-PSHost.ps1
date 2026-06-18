function Write-PSHost {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Text,
        [ConsoleColor]$ForegroundColor = "Gray",
        [ConsoleColor]$PrefixForegroundColor = "Yellow",
        [string]$Command = $null
    )
    $timestamp = (Get-Date).ToString($script:DateTimeStamp);
    $prefix = "[$timestamp][$ApplicationName]"
    if ([string]::IsNullOrEmpty($Command) -eq $false) {
        $prefix = "$prefix[$Command]"
    }
    Write-Host "$prefix " -ForegroundColor $PrefixForegroundColor -NoNewline;

    Write-Host $Text -ForegroundColor $ForegroundColor;
}
