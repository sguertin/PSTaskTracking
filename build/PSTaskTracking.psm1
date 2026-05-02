$script:AppName = "PSTaskTracking";
$script:DATE_FORMAT = "yyyy-MM-dd";
$script:DATETIME_FORMAT = "dddd M/d/yyyy h:m tt";

#{ModuleContent}#

if ([string]::IsNullOrEmpty($env:LOCALAPPDATA)) {
    $script:AppFolder = Join-Path -Path $env:HOME -ChildPath ".local" -AdditionalChildPath @($script:AppName);
} else {
    $script:AppFolder = Join-Path ($env:LOCALAPPDATA) -ChildPath $script:AppName;
}

$script:AppFolder = Join-Path ($appFolderPath) -ChildPath $script:AppName;
$script:Settings = Get-TaskTrackerSettings;

Initialize-PSTaskTracking;
