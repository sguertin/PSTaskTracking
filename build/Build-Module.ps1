param(
    [string]$Certificate = $null
)
$sourceDirectory = $PWD;
$buildSettings = Get-Content (Join-Path "build" -ChildPath "build.json" ) -Raw | ConvertFrom-Json -AsHashtable;
$applicationName = $buildSettings.ApplicationName
$continue = $true;
while (!$sourceDirectory.ToString().EndsWith($applicationName)) {
    $parentDirectory = Split-Path -Parent $PWD;
    if ($parentDirectory.ToString() -eq $sourceDirectory.ToString()) {
        Write-Error "Unable to find $applicationName directory!"
        $continue = $false;
    } else {
        $sourceDirectory = $parentDirectory;
    }
}
if ($continue) {
    $outputDirectory = Join-Path $PWD -ChildPath "build" -AdditionalChildPath @("output", $applicationName);
    $content = "";
    $functions = @();
    $aliases = @();
    if (Test-Path $outputDirectory) {
        Remove-Item $outputDirectory -Recurse -Force;
    }

    if (Test-Path "$outputDirectory.zip") {
        Remove-Item "$outputDirectory.zip" -Force;
    }
    New-Item $outputDirectory -ItemType Directory -Force | Out-Null;
    foreach ($file in Get-ChildItem -Path $sourceDirectory -File -Filter "*.ps1") {
        $functionContent = Get-Content $file -Raw;
        $content += "$functionContent`n`n";
        $function = $file.Name.Replace(".ps1", "");
        if (!$buildSettings.FunctionsToExclude.Contains($function)) {
            $functions += $function;
        }
        foreach ($match in ([regex]"Set-Alias -Name (.*?) -Value .*").Matches($functionContent)) {
            $aliases += $match.Groups[1].Value
        }
    }
    $applicationName = $buildSettings.ApplicationName
    $moduleContent = Get-Content (Join-Path "build" -ChildPath "Module.psm1") -Raw;
    $moduleContent = $moduleContent.Replace("#{ModuleContent}#", $content)
    $moduleContent = $moduleContent.Replace("#{ModuleVersion}#", $buildSettings.ModuleVersion);
    $moduleContent = $moduleContent.Replace("#{ApplicationName}#", $applicationName);
    
    $moduleOutputPath = Join-Path $outputDirectory -ChildPath "$applicationName.psm1";
    $manifestOutputPath = Join-Path $outputDirectory -ChildPath "$applicationName.psd1";
    $User = $env:USERNAME;
    if ([string]::IsNullOrEmpty($User)) {
        $User = $env:USER;
    }
    New-Item -Path $moduleOutputPath -ItemType File -Value $moduleContent -Force | Out-Null;
    New-ModuleManifest -Path $manifestOutputPath -Guid $buildSettings.ProjectId `
    -ModuleVersion $buildSettings.ModuleVersion;
    Update-ModuleManifest -Path $manifestOutputPath -RootModule "$applicationName.psm1" `
    -FunctionsToExport $functions -AliasesToExport $aliases -VariablesToExport @(("$applicationName"+"Version"));
    
    if ([string]::IsNullOrEmpty($Certificate) -eq $false) {
        try {
            $cert = Get-ChildItem $Certificate -CodeSigningCert -ErrorAction Stop | Select-Object -First 1 -ErrorAction Stop;
            if ($null -eq $cert) {
                throw "No Code Signing Cert found for '$Certificate'";
            }
            $timestampServer = "http://timestamp.digicert.com";
            Write-Host "Signing '$moduleOutputPath' with '$Certificate' Code Signing Certificate";
            Set-AuthenticodeSignature `
                -FilePath $moduleOutputPath `
                -Certificate $cert `
                -TimestampServer $timestampServer;
            Write-Host "Signing '$manifestOutputPath' with '$Certificate' Code Signing Certificate";
            Set-AuthenticodeSignature `
                -FilePath $manifestOutputPath `
                -Certificate $cert `
                -TimestampServer $timestampServer;
        } catch {
            Write-Error $_;
        }
    }
    Compress-Archive -Path $outputDirectory -CompressionLevel Optimal -DestinationPath $outputDirectory | Out-Null;
}
