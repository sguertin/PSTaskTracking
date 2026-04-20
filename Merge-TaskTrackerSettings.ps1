function Merge-TaskTrackerSettings {
    [CmdletBinding()]
    param(
        $Base,
        $Merge,
        $Save
    )
    $mergedSettings = @{
        Editor               = $Base?.Editor ?? $Merge.Editor;
        Morning              = @{
            Hour   = $Base?.Morning?.Hour ?? $Merge.Morning.Hour;
            Minute = $Base?.Morning?.Minute ?? $Merge.Morning.Minute;
        };
        Midday               = @{
            Hour   = $Base?.Midday?.Hour ?? $Merge.Midday.Hour;
            Minute = $Base?.Midday?.Minute ?? $Merge.Midday.Minute;
        };
        EndOfDay             = @{
            Hour   = $Base?.EndOfDay?.Hour ?? $Merge.EndOfDay.Hour;
            Minute = $Base?.EndOfDay?.Minute ?? $Merge.EndOfDay.Minute;
        };
        Report               = @{
            Hour   = $Base?.Report?.Hour ?? $Merge.Report.Hour;
            Minute = $Base?.Report?.Minute ?? $Merge.Report.Minute;
        };
        MarkdownToPdfCommand = $Base?.MarkdownToPdfCommand ?? $Merge.MarkdownToPdfCommand;
        OutputDirectory      = $Base?.OutputDirectory ?? $Merge.OutputDirectory;
    };
    if ($Save) {
        Backup-TaskTrackerSettings;
        Set-Content -Path (Get-TaskTrackerSettingsPath) -Value ($mergedSettings | ConvertTo-Json);
    }
    return $mergedSettings;
}