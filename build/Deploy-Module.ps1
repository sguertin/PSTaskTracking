$buildSettings = Get-Content (Join-Path "build" -ChildPath "build.json" ) -Raw | ConvertFrom-Json -AsHashtable;
$applicationName = $buildSettings.ApplicationName
$Source = Join-Path $PWD -ChildPath "build" -AdditionalChildPath @("output", $applicationName);
if ($IsWindows) {
    $Destination = Join-Path $env:USERPROFILE -ChildPath "Documents" -AdditionalChildPath @("PowerShell", "Modules");
} else {
    $Destination = Join-Path $env:HOME -ChildPath ".local" -AdditionalChildPath @("share", "powershell", "Modules");
}
Write-Output "$Source ====> $Destination";
Copy-Item -Path $Source -Destination $Destination -Recurse -Force;
