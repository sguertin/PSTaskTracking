function Write-PSVerbose {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Text,
        [string]$Command = $null
    )

    $timestamp = (Get-Date).ToString($script:DateTimeStamp);
    $prefix = "[$timestamp][$ApplicationName]"
    if ([string]::IsNullOrEmpty($Command) -eq $false) {
        $prefix = "$prefix[$Command]"
    }
    Write-Verbose "$prefix $Text";
}
