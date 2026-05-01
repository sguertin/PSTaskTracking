function Close-Day {
    <#
    .SYNOPSIS
    Creates end of day report, if it doesn't already exist, then launches a text editor on the newly created markdown file. 
    If an output file command is specified, that will be executed as well.    
    
    .EXAMPLE
    Close-Day
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [DateTime]$Date = (Get-Date)
    )

    $reportFile = New-EndOfDayReport -Date $Date;
    if ($null -eq $reportFile) {
        return;
    }
    $reportFilePath = $reportFile.FullName;
    $reportFileName = $reportFile.Name;
    & $script:Settings.Editor $reportFilePath;
    $mdToPdfCmd = $script:Settings.MarkdownToPdfCommand;
    
    if ([string]::IsNullOrEmpty($script:Settings.OutputDirectory)) {        
        $outputDirectory = Get-TaskFolder;
    } else {
        $outputDirectory = $script:Settings.OutputDirectory;
    }
    if ([string]::IsNullOrEmpty($mdToPdfCmd)) {
        Write-Host "COPY $reportFileName ====> $outputDirectory";
        Copy-Item -$reportFilePath -Destination (Join-Path $outputDirectory -ChildPath $reportFileName) -Force;
    } else {
        $outputFileName = $reportFileName.Replace(".md", ".pdf");
        $outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName;
        $outputCommand = $mdToPdfCmd.Replace("#{input}#", "`"$reportFilePath`"").Replace("#{output}#", "`"$outputFilePath`"");
        Write-Host "> $outputCommand";
        Invoke-Expression -Command $outputCommand | Out-Null;
        Write-Host "$outputFileName written to '$outputDirectory'";
    }    
}
Set-Alias -Name CloseDay -Value Close-Day;