function ConvertTo-TimeValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        [int]$Hour,
        [Parameter(Mandatory, Position = 2)]
        [int]$Minute
    )
    return $Hour + ($Minute / 60);
}
