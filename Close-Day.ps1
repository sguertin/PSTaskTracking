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
    Invoke-TextEditor -Path $reportFilePath;
    $mdToPdfCmd = $script:Settings.MarkdownToPdfCommand;
    
    if ([string]::IsNullOrEmpty($script:Settings.OutputDirectory)) {
        $outputDirectory = $script:TaskFolder 
    } else {
        $outputDirectory = $script:Settings.OutputDirectory;
    }

    if ([string]::IsNullOrEmpty($mdToPdfCmd)) {
        Write-PSHost "COPY $reportFileName ====> $outputDirectory";
        Copy-Item -$reportFilePath -Destination (Join-Path $outputDirectory -ChildPath $reportFileName) -Force;
    } else {
        $outputFileName = $reportFileName.Replace(".md", ".pdf");
        $outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName;
        $outputCommand = $mdToPdfCmd | Resolve-Tokens -Token "input" -Value "`"$reportFilePath`"" `
        | Resolve-Tokens -Token "output" -Value "`"$outputFilePath`"";
        Write-PSHost "> $outputCommand";
        Invoke-Expression -Command $outputCommand | Out-Null;
        Write-PSHost "$outputFileName written to '$outputDirectory'";
    }    
}
Set-Alias -Name CloseDay -Value Close-Day;
