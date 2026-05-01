function ConvertTo-TimeValue {
    param(
        [Parameter(Mandatory)]
        [float]$Hour, 
        [int]$Minute = 0
    )
    return $Hour + ($Minute / 60);
}