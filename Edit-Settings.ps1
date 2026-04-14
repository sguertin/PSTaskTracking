function Edit-Settings {
    [CmdletBinding()]
    param()
    
    $settingsFile = Join-Path (Get-TaskFolder) -ChildPath "settings.json";
    $oldSettingsContent = Get-Content $settingsFile -Raw;
    Write-Host "Editing $settingsFile..."
    
    & $env:PSTT_Editor $settingsFile;
    try {
        $settings = Get-Content $settingsFile | ConvertFrom-Json -ErrorAction Stop;
    } catch {
        Write-Error "Unable to convert new settings from json!"
        $revert = $true
    }
    if (!$revert) {
        try {
            Get-Command $settings.editor -ErrorAction Stop | Out-Null;
        } catch {
            Write-Error "Unable to find editor" + $settings.editor + "! Reverting changes to settings file!"
            $revert = $true;
        }
    }
    if ($revert) {
        Write-Warning "Problems were found with the new settings, reverting to original configuration..."
        Set-Content $settingsFile -Value $oldSettingsContent;
        $settings = $oldSettingsContent | ConvertFrom-Json;
    }
    $env:PSTT_Editor = $settings.editor;
    $env:PSTT_MorningHour = $settings.morning.hour;
    $env:PSTT_MorningMinute = $settings.morning.minute;
    $env:PSTT_MiddayHour = $settings.midday.hour;
    $env:PSTT_MiddayMinute = $settings.midday.minute;
    $env:PSTT_EndOfDayHour = $settings.endOfDay.hour;
    $env:PSTT_EndOfDayMinute = $settings.endOfDay.minute;
    $env:PSTT_CloseDayHour = $settings.report.hour;
    $env:PSTT_CloseDayMinute = $settings.report.minute;
}