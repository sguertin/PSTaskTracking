function Write-PSVerbose {
    param(
        [Parameter(Mandatory)]
        [string]$Text
    )
    $timestamp = (Get-Date).ToString($script:DateTimeStamp);
    
    Write-Verbose "[$timestamp][$ApplicationName] $Text";
}