function Update-TaskTrackerSettings {
    [CmdletBinding()]
    param()

    $editors = @("nano", "micro", "vim", "spacevim", "emacs", "astrovim", "nvim");
    $valid = $true;
    $originalSettings = Get-TaskTrackerSettings | ConvertTo-Json;
    $env:PSTT_PrevSettings = $originalSettings;
    Write-Verbose "Original Settings:`n$originalSettings`n";
    $settingsFilePath = Get-TaskTrackerSettingsPath;
    Start-Sleep 1;    
    & $env:PSTT_Editor $settingsFilePath;
    Start-Sleep 1;    
    $settings = Get-TaskTrackerSettings;
    
    if ($editors.Contains($settings.Editor) -eq $false) {
        Write-Warning  "'" + $settings.Editor + "' is not a known editor!"
    }
    $valid = (Assert-ValidTime -Hour $settings.Morning.Hour -Minute $settings.Morning.Minute -Label "Morning") -and (Assert-ValidTime -Hour $settings.Midday.Hour -Minute $settings.Midday.Minute -Label "Midday") -and (Assert-ValidTime -Hour $settings.EndOfDay.Hour -Minute $settings.EndOfDay.Minute -Label "EndOfDay") -and (Assert-ValidTime -Hour $settings.Report.Hour -Minute $settings.Report.Minute -Label "Report");
    if ($valid) {
        $morningGap = Measure-TimeGap $settings.Morning.Hour $settings.Morning.Minute $settings.Midday.Hour $settings.Midday.Minute;
        $middayGap = Measure-TimeGap $settings.Midday.Hour $settings.Midday.Minute $settings.EndOfDay.Hour $settings.EndOfDay.Minute;
        $endOfDayGap = Measure-TimeGap $settings.EndOfDay.Hour $settings.EndOfDay.Minute $settings.Report.Hour $settings.Report.Minute;
        $morningTime = $settings.Morning.Hour.ToString("00") + ":" + $settings.Morning.Minute.ToString("00");
        $endOfDayTime = $settings.EndOfDay.Hour.ToString("00") + ":" + $settings.EndOfDay.Minute.ToString("00");
        $middayTime = $settings.Midday.Hour.ToString("00") + ":" + $settings.Midday.Minute.ToString("00");
        $reportTime = $settings.Report.Hour.ToString("00") + ":" + $settings.Report.Minute.ToString("00");
        if ($morningGap -lt 1.0) {
            Write-Error ("Midday Time: $middayTime needs to be at least an hour after Morning Time: $morningTime, Current Gap: $morningGap hours");
            $valid = $false;
        }
        if ($middayGap -lt 1.0) {
            Write-Error ("EndOfDay Time: $middayTime needs to be at least an hour after Midday Time: $middayTime, Current Gap: $middayGap hours");
            $valid = $false;
        }
        if ($endOfDayGap -lt 0.25) {
            Write-Error ("Report Time: $reportTime needs to be at least fifteen minutes after EndOfDay Time: $endOfDayTime, Current Gap: $endOfDayGap hours");
            $valid = $false;
        }
    }
    if ($Rollback -or ($valid -eq $false)) {
        Write-Warning "No changes were committed to settings."
        Set-Content -Path $settingsFilePath -Value $originalSettings;
        return;
    } else {
        $newSettings = ConvertTo-Json $settings;
        Set-Content -Path $settingsFilePath -Value $newSettings;
        Sync-TaskTrackerSettings;
    }
}
