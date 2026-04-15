function Reset-Settings {
    [CmdletBinding()]
    param()
    $settingsFilePath = Get-TaskListSettings;

    $defaultSettings = Get-DefaultTaskListSettings;
    Write-Host "Restoring default settings..."
    Set-Content -Path $settingsFilePath -Value (ConvertTo-Json $defaultSettings);
    Write-Host "Settings restored to defaults."
    $env:PSTT_Editor = $defaultSettings.Editor;
    $env:PSTT_MorningHour = $defaultSettings.Morning.Hour;
    $env:PSTT_MorningMinute = $defaultSettings.Morning.Minute;
    $env:PSTT_MiddayHour = $defaultSettings.Midday.Hour;
    $env:PSTT_MiddayMinute = $defaultSettings.Midday.Minute;
    $env:PSTT_EndOfDayHour = $defaultSettings.EndOfDay.Hour;
    $env:PSTT_EndOfDayMinute = $defaultSettings.EndOfDay.Minute;
    $env:PSTT_CloseDayHour = $defaultSettings.Report.Hour;
    $env:PSTT_CloseDayMinute = $defaultSettings.Report.Minute;
    $env:PSTT_PdfOutput = $defaultSettings.MarkdownToPdfCommand;
    $env:PSTT_OutputDirectory = $defaultSettings.OutputDirectory;
}