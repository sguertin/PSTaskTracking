function Update-TaskTrackerSettings {
    [CmdletBinding()]
    param()

    $editors = @("nano", "micro", "vim", "spacevim", "emacs", "astrovim", "nvim", "neovim");
    $valid = $true;
    $originalSettings = Get-TaskTrackerSettings;
    
    Write-Verbose ("Original Settings:`n" + (ConvertTo-Json $originalSettings) + "`n");
    Start-Sleep 1;    
    & $script:Settings.Editor $script:SettingsFile;

    Start-Sleep 1;    
    $newSettings = Get-TaskTrackerSettings;
    Write-Verbose ("New Settings:`n" + (ConvertTo-Json $newSettings) + "`n");

    if ($editors.Contains($newSettings.Editor) -eq $false) {
        Write-PSWarning  "'" + $newSettings.Editor + "' is not a known editor!"
    }
    $valid = (Assert-ValidTime -Hour $newSettings.Morning.Hour -Minute $newSettings.Morning.Minute -Label "Morning") -and `
    (Assert-ValidTime -Hour $newSettings.Midday.Hour -Minute $newSettings.Midday.Minute -Label "Midday") -and `
    (Assert-ValidTime -Hour $newSettings.EndOfDay.Hour -Minute $newSettings.EndOfDay.Minute -Label "EndOfDay") -and `
    (Assert-ValidTime -Hour $newSettings.Report.Hour -Minute $newSettings.Report.Minute -Label "Report");
    if ($valid) {
        $morningGap = Measure-TimeGap $newSettings.Morning.Hour $newSettings.Morning.Minute $newSettings.Midday.Hour $newSettings.Midday.Minute;
        $middayGap = Measure-TimeGap $newSettings.Midday.Hour $newSettings.Midday.Minute $newSettings.EndOfDay.Hour $newSettings.EndOfDay.Minute;
        $endOfDayGap = Measure-TimeGap $newSettings.EndOfDay.Hour $newSettings.EndOfDay.Minute $newSettings.Report.Hour $newSettings.Report.Minute;
        $morningTime = $newSettings.Morning.Hour.ToString("00") + ":" + $newSettings.Morning.Minute.ToString("00");
        $endOfDayTime = $newSettings.EndOfDay.Hour.ToString("00") + ":" + $newSettings.EndOfDay.Minute.ToString("00");
        $middayTime = $newSettings.Midday.Hour.ToString("00") + ":" + $newSettings.Midday.Minute.ToString("00");
        $reportTime = $newSettings.Report.Hour.ToString("00") + ":" + $newSettings.Report.Minute.ToString("00");
        if ($morningGap -lt 1.0) {
            Write-PSHost ("Midday Time: $middayTime needs to be at least an hour after Morning Time: $morningTime, Current Gap: $morningGap hours") -ForegroundColor Red;
            $valid = $false;
        }
        if ($middayGap -lt 1.0) {
            Write-PSHost ("EndOfDay Time: $middayTime needs to be at least an hour after Midday Time: $middayTime, Current Gap: $middayGap hours") -ForegroundColor Red;
            $valid = $false;
        }
        if ($endOfDayGap -lt 0.25) {
            Write-PSHost ("Report Time: $reportTime needs to be at least fifteen minutes after EndOfDay Time: $endOfDayTime, Current Gap: $endOfDayGap hours") -ForegroundColor Red;
            $valid = $false;
        }
    }
    if ($Rollback -or ($valid -eq $false)) {
        Write-PSWarning "No changes were committed to settings."
        Set-Content -Path $script:SettingsFile -Value (ConvertTo-Json $originalSettings);
        return;
    } else {
        $newSettings = ConvertTo-Json $newSettings;
        Set-Content -Path $script:SettingsFile -Value (ConvertTo-Json $newSettings);
        Sync-TaskTrackerSettings;
    }
}
