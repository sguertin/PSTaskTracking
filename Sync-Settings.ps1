function Sync-Settings {
    [CmdletBinding()]
    param()

    $settings = Get-Content $settingsFile | ConvertFrom-Json;
    $env:PSTT_Editor = $settings.Editor;
    $env:PSTT_MorningHour = $settings.Morning.Hour;
    $env:PSTT_MorningMinute = $settings.Morning.Minute;
    $env:PSTT_MiddayHour = $settings.Midday.Hour;
    $env:PSTT_MiddayMinute = $settings.Midday.Minute;
    $env:PSTT_EndOfDayHour = $settings.EndOfDay.Hour;
    $env:PSTT_EndOfDayMinute = $settings.EndOfDay.Minute;
    $env:PSTT_CloseDayHour = $settings.Report.Hour;
    $env:PSTT_CloseDayMinute = $settings.Report.Minute;
    $env:PSTT_PdfOutput = $settings.MarkdownToPdfCommand;
    $env:PSTT_OutputDirectory = $settings.OutputDirectory;
    
}