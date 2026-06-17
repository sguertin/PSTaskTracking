function Update-TaskTrackerSettings {
    [CmdletBinding()]
    param(
        [switch]$Rollback
    )
    $currentSettings = $script:Settings | ConvertTo-Json;
    if (Test-Path $script:TempSettingsFile) {
        Set-Content -Path $script:TempSettingsFile -Value $currentSettings -NoNewLine | Out-Null;
    } else {
        New-Item -Path $script:TempSettingsFile -ItemType File -Value $currentSettings | Out-Null;
    }
    
    Write-PSVerbose ("Original Settings:`n$currentSettings`n");
    Start-Sleep 1;
    Invoke-TextEditor -Path $script:TempSettingsFile;
    Start-Sleep 1;
    try {
        $newSettings = Get-Content $script:TempSettingsFile -Raw | ConvertFrom-Json -AsHashtable -ErrorAction Stop;
    } catch {
        Write-PSError "The new settings file is invalid JSON!";
        Remove-Item $script:TempSettingsFile;
        return;
    }
    $editors = @("nano", "micro", "vim", "spacevim", "emacs", "astrovim", "nvim", "neovim");
    Write-PSVerbose ("New Settings:`n" + (ConvertTo-Json $newSettings) + "`n");

    if ($editors.Contains($newSettings.Editor) -eq $false) {
        Write-PSWarning  ("`"" + $newSettings.Editor + "`" is not a known terminal editor!")
    }
    $validTime = (Assert-ValidTime $newSettings.Morning.Hour $newSettings.Morning.Minute "Morning") -and `
    (Assert-ValidTime $newSettings.Midday.Hour $newSettings.Midday.Minute "Midday") -and `
    (Assert-ValidTime $newSettings.EndOfDay.Hour $newSettings.EndOfDay.Minute "EndOfDay") -and `
    (Assert-ValidTime $newSettings.Report.Hour $newSettings.Report.Minute "Report");
    if ($validTime) {
        $morningGap = (ConvertTo-TimeValue $newSettings.Midday.Hour $newSettings.Midday.Minute) `
            - (ConvertTo-TimeValue $newSettings.Morning.Hour $newSettings.Morning.Minute);
        $middayGap = (ConvertTo-TimeValue $newSettings.EndOfDay.Hour $newSettings.EndOfDay.Minute) `
            - (ConvertTo-TimeValue $newSettings.Midday.Hour $newSettings.Midday.Minute);
        $endOfDayGap = (ConvertTo-TimeValue $newSettings.Report.Hour $newSettings.Report.Minute) `
            - (ConvertTo-TimeValue $newSettings.EndOfDay.Hour $newSettings.EndOfDay.Minute);
        $morningTime = $newSettings.Morning.Hour.ToString("00") + ":" + $newSettings.Morning.Minute.ToString("00");
        $endOfDayTime = $newSettings.EndOfDay.Hour.ToString("00") + ":" + $newSettings.EndOfDay.Minute.ToString("00");
        $middayTime = $newSettings.Midday.Hour.ToString("00") + ":" + $newSettings.Midday.Minute.ToString("00");
        $reportTime = $newSettings.Report.Hour.ToString("00") + ":" + $newSettings.Report.Minute.ToString("00");
        if ($morningGap -lt 1.0) {
            Write-PSError ("Midday Time: $middayTime needs to be at least an hour after Morning Time: $morningTime, Current Gap: $morningGap hours");
            $validTime = $false;
        }
        if ($middayGap -lt 1.0) {
            Write-PSError ("EndOfDay Time: $middayTime needs to be at least an hour after Midday Time: $middayTime, Current Gap: $middayGap hours");
            $validTime = $false;
        }
        if ($endOfDayGap -lt 0.25) {
            Write-PSError ("Report Time: $reportTime needs to be at least fifteen minutes after EndOfDay Time: $endOfDayTime, Current Gap: $endOfDayGap hours");
            $validTime = $false;
        }
    }
    if ([string]::IsNullOrEmpty($newSettings.OutputDirectory) `
            -or (Test-Path -Path $newSettings.OutputDirectory -IsValid)) {
        $validOutputDirectory = $true;
    } else {
        $validOutputDirectory = $false;
        Write-PSError ("Output Directory: " + $newSettings.OutputDirectory + " is not a valid file path!");
    }
    if ($Rollback -or ($validTime -eq $false) -or ($validOutputDirectory -eq $false)) {
        Write-PSWarning "No changes were committed to settings.";
    } else {
        Set-Content -Path $script:SettingsFile -Value (Get-Content $script:TempSettingsFile -Raw);
        Sync-TaskTrackerSettings | Out-Null;
    }
    Remove-Item $script:TempSettingsFile;
}
