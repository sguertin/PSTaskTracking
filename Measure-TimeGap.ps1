function Measure-TimeGap {
    [CmdletBinding()]
    param(
        [ValidateRange(1, 23)][Parameter(Position = 1)]
        [int]$FirstHour = $null,
        [ValidateRange(0, 59)][Parameter(Position = 2)]
        [int]$FirstMinute = $null,
        [ValidateRange(1, 23)][Parameter(Position = 3)]
        [int]$SecondHour = $null,
        [ValidateRange(0, 59)][Parameter(Position = 4)]
        [int]$SecondMinute = $null
    )
    $firstTimeValue = $FirstHour + ($FirstMinute / 60);
    $secondTimeValue = $SecondHour + ($SecondMinute / 60);

    return $secondTimeValue - $firstTimeValue;
}