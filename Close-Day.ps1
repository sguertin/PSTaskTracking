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
    $reportFileName = $reportFile.FullName;
    & $script:Settings.Editor $reportFileName;
    
    if ([string]::IsNullOrEmpty($script:Settings.MarkdownToPdfCommand)) {        
        return;
    }
    if ([string]::IsNullOrEmpty($script:Settings.OutputDirectory)) {
        $outputDirectory = Get-TaskFolder;
    } else {
        $outputDirectory = $script:Settings.OutputDirectory;
    }
    $outputFileName = $reportFile.Name.Replace(".md", ".pdf");
    $outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName;
    $outputCommand = $script:Settings.MarkdownToPdfCommand.Replace("#{input}#", "`"$reportFileName`"").Replace("#{output}#", "`"$outputFilePath`"");
    Write-Host "> $outputCommand";
    Invoke-Expression -Command $outputCommand | Out-Null;
    Write-Host "$outputFileName written to '$outputDirectory'";
}
Set-Alias -Name CloseDay -Value Close-Day;