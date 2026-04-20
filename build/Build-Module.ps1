$sourceDirectory = $PWD;
$continue = $true;
while (!$sourceDirectory.ToString().EndsWith("PSTaskTracking")) {
    $parentDirectory = Split-Path -Parent $PWD;
    if ($parentDirectory.ToString() -eq $sourceDirectory.ToString()) {
        Write-Error "Unable to find PSTaskTracking directory!"
        $continue = $false;
    }
    else {
        $sourceDirectory = $parentDirectory;
    }
}
if ($continue) {
    $settings = Get-Content (Join-Path "build" -ChildPath "build.json" ) -Raw | ConvertFrom-Json;
    $outputDirectory = Join-Path $PWD -ChildPath "Module" -AdditionalChildPath @("PSTaskTracking");
    $archiveFilePath = Join-Path $PWD -ChildPath "Module" -AdditionalChildPath @("PSTaskTracking");
    $content = "";
    $functions = @();
    $aliases = @();
    if (Test-Path $outputDirectory) {
        Remove-Item $outputDirectory -Recurse -Force;
    }

    if (Test-Path "$archiveFilePath.zip") {
        Remove-Item "$archiveFilePath.zip" -Force;
    }
    New-Item $outputDirectory -ItemType Directory -Force | Out-Null;
    foreach ($file in Get-ChildItem -Path $sourceDirectory -File -Filter "*.ps1") {
        $functionContent = Get-Content $file -Raw;
        $content += "$functionContent`n`n";
        $function = $file.Name.Replace(".ps1", "");
        if (!$settings.FunctionsToExclude.Contains($function)) {
            $functions += $function;
        }
        foreach ($match in ([regex]"Set-Alias -Name (.*?) -Value .*").Matches($functionContent)) {
            $aliases += $match.Groups[1].Value
        }
    }
    $moduleContent = Get-Content (Join-Path "build" -ChildPath "PSTaskTracking.psm1") -Raw;
    $moduleContent = $moduleContent.Replace("#{ModuleContent}#", $content);
    $moduleOutputPath = Join-Path $outputDirectory -ChildPath "PSTaskTracking.psm1";
    $manifestOutputPath = Join-Path $outputDirectory -ChildPath "PSTaskTracking.psd1";
    $User = $env:USERNAME;
    if ([string]::IsNullOrEmpty($User)) {
        $User = $env:USER;
    }
    New-Item -Path $moduleOutputPath -ItemType File -Value $moduleContent -Force | Out-Null;
    New-ModuleManifest -Path $manifestOutputPath -Guid $settings.ProjectId -ModuleVersion $settings.ModuleVersion;
    Update-ModuleManifest -Path $manifestOutputPath -RootModule "PSTaskTracking.psm1" -FunctionsToExport $functions -AliasesToExport $aliases;
    Compress-Archive -Path $outputDirectory -CompressionLevel Optimal -DestinationPath $archiveFilePath;
}
