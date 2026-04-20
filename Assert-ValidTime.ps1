function Assert-ValidTime {
    param(
        [int]$Hour,
        [int]$Minute,
        [string]$Label
    )

    $hourValid = ($Hour -le 23) -and ($Hour -ge 0);
    if ($hourValid -eq $false) {
        Write-Error "$Label.Hour: $Hour is Invalid, expected a value between 0 and 23";
    }
    $minuteValid = ($Minute -le 59) -and ($Minute -ge 0);
    if ($minuteValid -eq $false) {
        Write-Error "$Label.Minute: $Minute is Invalid, expected a value between 0 and 59";
    }
    return $hourValid -and $minuteValid;
}
