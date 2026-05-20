function Update-TaskTrackerSettings {
    [CmdletBinding()]
    param(
        [switch]$Rollback
    )

    $editors = @("nano", "micro", "vim", "spacevim", "emacs", "astrovim", "nvim", "neovim");
    $valid = $true;
    $originalSettings = Get-TaskTrackerSettings;

    Write-Verbose ("Original Settings:`n" + (ConvertTo-Json $originalSettings) + "`n");
    Start-Sleep 1;

    & $script:Settings.Editor $script:SettingsFile;

    Start-Sleep 1;
    try {
        $newSettings = Get-Content $script:SettingsFile -Raw | ConvertFrom-Json -ErrorAction Stop;
    } catch {
        Write-PSError "The new settings file is invalid JSON! Reverting...";
        Set-Content -Path $script:SettingsFile -Value (ConvertTo-Json $originalSettings);
        return;
    }

    Write-Verbose ("New Settings:`n" + (ConvertTo-Json $newSettings) + "`n");

    if ($editors.Contains($newSettings.Editor) -eq $false) {
        Write-PSWarning  ("`"" + $newSettings.Editor + "`" is not a known terminal editor!")
    }
    $valid = (Assert-ValidTime $newSettings.Morning.Hour $newSettings.Morning.Minute "Morning") -and `
    (Assert-ValidTime $newSettings.Midday.Hour $newSettings.Midday.Minute "Midday") -and `
    (Assert-ValidTime $newSettings.EndOfDay.Hour $newSettings.EndOfDay.Minute "EndOfDay") -and `
    (Assert-ValidTime $newSettings.Report.Hour $newSettings.Report.Minute "Report");
    if ($valid) {
        $morningGap = ConvertTo-TimeValue $newSettings.Midday.Hour $newSettings.Midday.Minute `
            - ConvertTo-TimeValue $newSettings.Morning.Hour $newSettings.Morning.Minute;
        $middayGap = ConvertTo-TimeValue $newSettings.EndOfDay.Hour $newSettings.EndOfDay.Minute `
            - ConvertTo-TimeValue $newSettings.Midday.Hour $newSettings.Midday.Minute;
        $endOfDayGap = ConvertTo-TimeValue $newSettings.Report.Hour $newSettings.Report.Minute `
            - ConvertTo-TimeValue $newSettings.EndOfDay.Hour $newSettings.EndOfDay.Minute;
        $morningTime = $newSettings.Morning.Hour.ToString("00") + ":" + $newSettings.Morning.Minute.ToString("00");
        $endOfDayTime = $newSettings.EndOfDay.Hour.ToString("00") + ":" + $newSettings.EndOfDay.Minute.ToString("00");
        $middayTime = $newSettings.Midday.Hour.ToString("00") + ":" + $newSettings.Midday.Minute.ToString("00");
        $reportTime = $newSettings.Report.Hour.ToString("00") + ":" + $newSettings.Report.Minute.ToString("00");
        if ($morningGap -lt 1.0) {
            Write-PSError ("Midday Time: $middayTime needs to be at least an hour after Morning Time: $morningTime, Current Gap: $morningGap hours");
            $valid = $false;
        }
        if ($middayGap -lt 1.0) {
            Write-PSError ("EndOfDay Time: $middayTime needs to be at least an hour after Midday Time: $middayTime, Current Gap: $middayGap hours");
            $valid = $false;
        }
        if ($endOfDayGap -lt 0.25) {
            Write-PSError ("Report Time: $reportTime needs to be at least fifteen minutes after EndOfDay Time: $endOfDayTime, Current Gap: $endOfDayGap hours");
            $valid = $false;
        }
    }
    if ([string]::IsNullOrEmpty($newSettings.OutputDirectory) -eq $false) {
        if ((Test-Path -Path $newSettings.OutputDirectory -IsValid) -eq $false) {
            Write-PSError ("Output Directory: " + $newSettings.OutputDirectory + " is not a valid file path!");
            $valid = $false;
        }
    }
    if ($Rollback -or ($valid -eq $false)) {
        Write-PSWarning "No changes were committed to settings."
        Set-Content -Path $script:SettingsFile -Value (ConvertTo-Json $originalSettings);
        return;
    } else {
        $content = ConvertTo-Json $newSettings;
        Set-Content -Path $script:SettingsFile -Value $content;
        Sync-TaskTrackerSettings | Out-Null;
    }
}
