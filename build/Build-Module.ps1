$sourceDirectory = $PWD;
$continue = $true;
while (!$sourceDirectory.ToString().EndsWith("PSTaskTracking")) {
    $parentDirectory = Split-Path -Parent $PWD;
    if ($parentDirectory.ToString() -eq $sourceDirectory.ToString()) {
        Write-Error "Unable to find PSTaskTracking directory!"
        $continue = $false;
    } else {
        $sourceDirectory = $parentDirectory;
    }    
}
if ($continue) {
    $settings = Get-Content (Join-Path "build" -ChildPath "build.json" ) -Raw | ConvertFrom-Json;
    $aliasRegex = "Set-Alias -Name (.*?) -Value .*"
    $outputDirectory = Join-Path $PWD -ChildPath "PSTaskTracking";
    $content = ""; 
    $functions = @();
    $aliases = @();
    if (Test-Path $outputDirectory) {        
        Remove-Item $outputDirectory -Recurse -Force;
    }
    New-Item $outputDirectory -ItemType Directory -Force | Out-Null;
    foreach ($file in Get-ChildItem -Path $sourceDirectory -File -Filter "*.ps1" | Where-Object Name -NE "Update-Module.ps1") {
        $functionContent = Get-Content $file -Raw; 
        $content += "$functionContent`n"; 
        $functions += $file.Name.Replace(".ps1", "");
        foreach ($match in ([regex]$aliasRegex).Matches($functionContent)) {
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
    New-ModuleManifest -Path $manifestOutputPath -Guid $settings.ProjectId -ModuleVersion '2.0';
    Update-ModuleManifest -Path $manifestOutputPath -RootModule "PSTaskTracking.psm1" -FunctionsToExport $functions -AliasesToExport $aliases;
}
