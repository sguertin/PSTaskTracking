$settingsFile = Join-Path $env:LOCALAPPDATA -ChildPath (Join-Path "PSTaskTracking" -ChildPath "settings.json");
$settingsDefaultContent = "{
    `"editor`": `"micro`",
    `"morning`": {
        `"hour`": 0,
        `"minute`": 0
    },
    `"midday`": {
        `"hour`": 12,
        `"minute`": 0
    },
    `"endOfDay`": {
        `"hour`": 15,
        `"minute`": 0
    },
    `"report`": {
        `"hour`": 15,
        `"minute`": 30
    }
}";
if ((Test-Path $settingsFile) -eq $false) {
    New-Item $settingsFile -ItemType File -Value $settingsDefaultContent -Force;
}
$settings = Get-Content $settingsFile | ConvertFrom-Json;
$env:PSTT_Editor = $settings.editor;
$env:PSTT_MorningHour = $settings.morning.hour;
$env:PSTT_MorningMinute = $settings.morning.minute;
$env:PSTT_MiddayHour = $settings.midday.hour;
$env:PSTT_MiddayMinute = $settings.midday.minute;
$env:PSTT_EndOfDayHour = $settings.endOfDay.hour;
$env:PSTT_EndOfDayMinute = $settings.endOfDay.minute;
$env:PSTT_CloseDayHour = $settings.report.hour;
$env:PSTT_CloseDayMinute = $settings.report.minute;

#{ModuleContent}#