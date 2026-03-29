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
    $content = ""; 
    $functions = @();
    foreach ($file in Get-ChildItem -Path $sourceDirectory -File -Filter "*.ps1" | Where-Object Name -NE "Update-Module.ps1") { 
        $content += Get-Content $file -Raw; $content += "`n"; 
        $functions += $file.Name.Replace(".ps1", "");
    } 
    Set-Content .\PSTaskTracking.psm1 -Value $content;
    Update-ModuleManifest -Path .\PSTaskTracking.psd1 -FunctionsToExport @functions;
}
