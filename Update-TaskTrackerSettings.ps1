function Update-TaskTrackerSettings {
    [CmdletBinding()]
    param(
        [ValidateSet("nano", "micro", "vim", "spacevim", "emacs", "astrovim", "nvim")]
        [AllowNull()]
        [string]$Editor = $null,
        [ValidateRange(1, 23)]
        [AllowNull()]
        [int]$MorningHour = $null,
        [ValidateRange(0, 59)]
        [AllowNull()]
        [int]$MorningMinute = $null,
        [ValidateRange(1, 23)]
        [AllowNull()]
        [int]$MiddayHour = $null,
        [ValidateRange(0, 59)]
        [AllowNull()]
        [int]$MiddayMinute = $null,
        [ValidateRange(1, 23)]
        [AllowNull()]
        [int]$EndOfDayHour = $null,
        [ValidateRange(0, 59)]
        [AllowNull()]
        [int]$EndOfDayMinute = $null,
        [string]$OutputDirectory = $null,
        [string]$MarkdownToPdfCommand = $null,
        [switch]$Rollback
    )
    $validationFailed = $false;
    $settings = Get-TaskTrackerSettings;
    Write-Verbose "Original Settings:"
    Write-Verbose ("MarkdownToPdfCommand: '" + $settings.MarkdownToPdfCommand + "'");
    Write-Verbose ("OutputDirectory: '" + $settings.OutputDirectory + "'");
    Write-Verbose ("Editor: '" + $settings.Editor + "'");
    Write-Verbose ("Morning.Hour: " + $settings.Morning.Hour + "`nMorning.Minute: " + $settings.Morning.Minute );
    Write-Verbose ("Midday.Hour: " + $settings.Midday.Hour + "`nMidday.Minute: " + $settings.Midday.Minute );
    Write-Verbose ("EndOfDay.Hour: " + $settings.EndOfDay.Hour + "`nEndOfDay.Minute: " + $settings.EndOfDay.Minute );
    Write-Verbose ("Report.Hour: " + $settings.Report.Hour + "`nReport.Minute: " + $settings.Report.Minute);


    $settings.Editor = $Editor ?? $settings.Editor;
    $settings.OutputDirectory = $OutputDirectory ?? $settings.OutputDirectory;
    $settings.MarkdownToPdfCommand = $MarkdownToPdfCommand ?? $settings.MarkdownToPdfCommand;
    if ($null -eq $MorningHour) {
        $MorningHour = $settings.Morning.Hour;
    }
    else {
        $settings.Morning.Hour = $MorningHour;
    }
    $settings.Morning.Hour = $MorningHour ?? $settings.Morning.Hour;
    $settings.Morning.Minute = $MorningMinute ?? $settings.Morning.Minute;
    $morningGap = Measure-TimeGap $settings.Morning.Hour $settings.Morning.Minute $settings.Midday.Hour $settings.Midday.Minute;
    $morningTime = $settings.Morning.Hour.ToString("00") + ":" + $settings.Morning.Minute.ToString("00");

    $settings.Midday.Hour = $MiddayHour ?? $settings.Midday.Hour;
    $settings.Midday.Minute = $MiddayMinute ?? $settings.Midday.Minute;
    $middayGap = Measure-TimeGap $settings.Midday.Hour $settings.Midday.Minute $settings.EndOfDay.Hour $settings.EndOfDay.Minute;
    $middayTime = $settings.Midday.Hour.ToString("00") + ":" + $settings.Midday.Minute.ToString("00");

    $settings.EndOfDay.Hour = $EndOfDayHour ?? $settings.EndOfDay.Hour;
    $settings.EndOfDay.Minute = $EndOfDayMinute ?? $settings.EndOfDay.Minute;
    $endOfDayGap = Measure-TimeGap $settings.EndOfDay.Hour $settings.EndOfDay.Minute $settings.Report.Hour $settings.Report.Minute;
    $endOfDayTime = $settings.EndOfDay.Hour.ToString("00") + ":" + $settings.EndOfDay.Minute.ToString("00");

    $settings.Report.Hour = $EndOfDayHour ?? $settings.Report.Hour;
    $settings.Report.Minute = $EndOfDayMinute ?? $settings.Report.Minute;
    $reportTime = $settings.Report.Hour.ToString("00") + ":" + $settings.Report.Minute.ToString("00");

    if ($morningGap -lt 1.0) {
        Write-Error ("Midday Time: $middayTime needs to be at least an hour after Morning Time: $morningTime, Current Gap: $morningGap hours");
        $validationFailed = $true;
    }

    if ($middayGap -lt 1.0) {
        Write-Error ("EndOfDay Time: $middayTime needs to be at least an hour after Midday Time: $middayTime, Current Gap: $middayGap hours");
        $validationFailed = $true;
    }

    if ($endOfDayGap -lt 0.25) {
        Write-Error ("Report Time: $reportTime needs to be at least fifteen minutes after EndOfDay Time: $endOfDayTime, Current Gap: $endOfDayGap hours");
        $validationFailed = $true;
    }

    if ($Rollback -or $validationFailed) {
        Write-Warning "No changes were committed to settings."
        return;
    }
    else {
        Set-Content -Path $settingsFilePath -Value (ConvertTo-Json $settings);

        Sync-TaskTrackerSettings;
    }
}