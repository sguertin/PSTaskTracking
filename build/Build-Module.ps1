param(
    [string]$Certificate = $null
)
$sourceDirectory = $PWD;
$buildSettings = Get-Content (Join-Path "build" -ChildPath "build.json" ) -Raw `
| ConvertFrom-Json -AsHashtable;
$applicationName = $buildSettings.ApplicationName
$continue = $true;

while ($sourceDirectory.ToString().EndsWith($applicationName) -eq $false) {
    $parentDirectory = Split-Path -Parent $PWD;
    if ($parentDirectory.ToString().EndsWith($applicationName) -eq $false) {
        Write-Error "Unable to find $applicationName directory!"
        return;
    } else {
        $sourceDirectory = $parentDirectory;
    }
}
if ($continue) {
    $outputDirectory = Join-Path $PWD -ChildPath "build" -AdditionalChildPath @("output", $applicationName);
    $aliases = @();
    if (Test-Path $outputDirectory) {
        Remove-Item $outputDirectory -Recurse -Force;
    }

    if (Test-Path "$outputDirectory.zip") {
        Remove-Item "$outputDirectory.zip" -Force;
    }
    Write-Output "Building $ApplicationName.psm1...";
    New-Item $outputDirectory -ItemType Directory -Force | Out-Null;
    $files = Get-ChildItem -Path $sourceDirectory -File -Filter "*.ps1"
    $functions = $files | Where-Object BaseName -NotIn $buildSettings.FunctionsToExclude | Select-Object -ExpandProperty BaseName;
    $buildSettings.FunctionContent = $files | Get-Content -Raw | Join-String;
    foreach ($match in ([regex]"Set-Alias -Name (.*?) -Value .*").Matches($buildSettings.FunctionContent)) {
        $aliases += $match.Groups[1].Value
    }
    $moduleContent = Get-Content (Join-Path "Module" -ChildPath "Module.psm1") -Raw;
    foreach ($key in $buildSettings.Keys) {
        $moduleContent = $moduleContent.Replace("#{$key}#", $buildSettings[$key]);
    }
    $moduleOutputPath = Join-Path $outputDirectory -ChildPath "$applicationName.psm1";
    $manifestOutputPath = Join-Path $outputDirectory -ChildPath "$applicationName.psd1";

    New-Item -Path $moduleOutputPath -ItemType File -Value $moduleContent -Force | Out-Null;
    Write-Output "$applicationName.psm1 ====> $outputDirectory";
    New-ModuleManifest -Path $manifestOutputPath -Guid $buildSettings.ProjectId `
        -ModuleVersion $buildSettings.ModuleVersion;
    Update-ModuleManifest -Path $manifestOutputPath -RootModule "$applicationName.psm1" `
        -FunctionsToExport $functions -AliasesToExport $aliases -VariablesToExport @(("$applicationName" + "Version"));

    if ([string]::IsNullOrEmpty($Certificate) -eq $false) {
        try {
            $cert = Get-ChildItem -Path "Cert:\CurrentUser\$Certificate" -CodeSigningCert -ErrorAction Stop | Select-Object -First 1 -ErrorAction Stop;
            if ($null -eq $cert) {
                throw "No Code Signing Cert found for '$Certificate'";
            }
            $private:TimestampServer = "http://timestamp.digicert.com";
            Write-Host "Signing '$moduleOutputPath' with '$Certificate' Code Signing Certificate";
            Set-AuthenticodeSignature `
                -FilePath $moduleOutputPath `
                -Certificate $cert `
                -TimestampServer $private:TimestampServer `
                -ErrorAction Stop;
            Write-Host "Signing '$manifestOutputPath' with '$Certificate' Code Signing Certificate";
            Set-AuthenticodeSignature `
                -FilePath $manifestOutputPath `
                -Certificate $cert `
                -TimestampServer $private:TimestampServer `
                -ErrorAction Stop;
        } catch {
            Write-Host $_;
        }
    }
    Compress-Archive -Path $outputDirectory -CompressionLevel Optimal -DestinationPath $outputDirectory | Out-Null;
}
