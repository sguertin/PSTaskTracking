function Assert-ValidTime {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        [int]$Hour,
        [Parameter(Mandatory, Position = 2)]
        [int]$Minute,
        [Parameter(Mandatory, Position = 3)]
        [string]$Label
    )

    $hourValid = ($Hour -le 23) -and ($Hour -ge 0);
    if ($hourValid -eq $false) {
        Write-PSError "$Label.Hour: $Hour is Invalid, expected a value between 0 and 23";
    }
    $minuteValid = ($Minute -le 59) -and ($Minute -ge 0);
    if ($minuteValid -eq $false) {
        Write-PSError "$Label.Minute: $Minute is Invalid, expected a value between 0 and 59";
    }
    return $hourValid -and $minuteValid;
}
