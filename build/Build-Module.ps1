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
    $aliasRegex = "Set-Alias -Name (.*?) -Value .*"
    $outputDirectory = Join-Path $PWD -ChildPath "output";
    $content = ""; 
    $functions = @();
    $aliases = @();
    foreach ($file in Get-ChildItem -Path $sourceDirectory -File -Filter "*.ps1" | Where-Object Name -NE "Update-Module.ps1") {
        $functionContent = Get-Content $file -Raw; 
        $content += "$functionContent`n"; 
        $functions += $file.Name.Replace(".ps1", "");
        foreach ($match in ([regex]$aliasRegex).Matches($functionContent)) {
            $aliases += $match.Groups[1].Value
        }
    } 
    $moduleContent = Get-Content (Join-Path ".build" -ChildPath "PSTaskTracking.psm1") -Raw;
    $moduleContent = $moduleContent.Replace("#{ModuleContent}#", $content);
    $moduleOutputPath = Join-Path $outputDirectory -ChildPath "PSTaskTracking.psm1";
    $manifestOutputPath = Join-Path $outputDirectory -ChildPath "PSTaskTracking.psd1";
    Copy-Item (Join-Path ".build" -ChildPath "PSTaskTracking.psd1") -Destination $manifestOutputPath -Force;
    Update-ModuleManifest -Path $manifestOutputPath -FunctionsToExport $functions -AliasesToExport $aliases;
    New-Item -Path $moduleOutputPath -ItemType File -Value $moduleContent -Force;    
}
