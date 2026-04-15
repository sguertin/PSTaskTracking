function Measure-TimeGap {
    [CmdletBinding()]
    param(
        [ValidateRange(1, 23)][Parameter(Mandatory, Position = 1)]
        [int]$FirstHour,
        [ValidateRange(0, 59)][Parameter(Position = 2)]
        [int]$FirstMinute = 0,
        [ValidateRange(1, 23)][Parameter(Mandatory, Position = 3)]
        [int]$SecondHour,
        [ValidateRange(0, 59)][Parameter(Position = 4)]
        [int]$SecondMinute = 0
    )
    $firstTimeValue = $FirstHour + ($FirstMinute / 60);
    $secondTimeValue = $SecondHour + ($SecondMinute / 60);

    return $secondTimeValue - $firstTimeValue;
}