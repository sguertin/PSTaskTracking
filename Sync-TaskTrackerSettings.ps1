function Sync-TaskTrackerSettings {
    [CmdletBinding()]
    param()

    $script:Settings = Get-TaskTrackerSettings;
    $script:MorningTime = ConvertTo-TimeValue -Hour $script:Settings.Morning.Hour -Minute $script:Settings.Morning.Minute;
    $script:MiddayTime = ConvertTo-TimeValue -Hour $script:Settings.Midday.Hour -Minute $script:Settings.Midday.Minute;
    $script:EndOfDayTime = ConvertTo-TimeValue -Hour $script:Settings.EndOfDay.Hour -Minute $script:Settings.EndOfDay.Minute;
    $script:CloseDayTime = ConvertTo-TimeValue -Hour $script:Settings.Report.Hour -Minute $script:Settings.Report.Minute;

    foreach ($key in $script:DefaultSettings.Keys) {
        if (!$script:Settings.ContainsKey($key)) {
            $script:Settings[$key] = $defaultSettings[$key]
        }
    }
    return $script:Settings;
}
