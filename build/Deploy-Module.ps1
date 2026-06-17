$buildSettings = Get-Content (Join-Path "build" -ChildPath "build.json" ) -Raw | ConvertFrom-Json -AsHashtable;
$applicationName = $buildSettings.ApplicationName
$Source = Join-Path $PWD -ChildPath "build" -AdditionalChildPath @("output", $applicationName);
if ($IsLinux) {    
    $Destination = Join-Path $env:HOME -ChildPath ".local" -AdditionalChildPath @("share", "powershell", "Modules");
} else {
    $Destination = Join-Path $env:USERPROFILE -ChildPath "Documents" -AdditionalChildPath @("PowerShell", "Modules");
}
Copy-Item -Path $Source -Destination $Destination -Recurse -Force;