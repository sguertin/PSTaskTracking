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
    & $env:PSTT_Editor $reportFile.FullName;
    
    if ([string]::IsNullOrEmpty($env:PSTT_PdfOutput)) {        
        return;
    }
    if ([string]::IsNullOrEmpty($env:PSTT_OutputDirectory)) {
        $outputDirectory = Get-TaskFolder;
    } else {
        $outputDirectory = $env:PSTT_OutputDirectory;
    }
    $outputFileName = $reportFile.Name.Replace(".md", ".pdf");
    $outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName;
    $outputCommand = $env:PSTT_PdfOutput.Replace("#{input}#", "`"" + $reportFile.FullName + "`"").Replace("#{output}#", "`"$outputFilePath`"");
    Invoke-Expression -Command $outputCommand | Out-Null;
    Write-Host "$outputFileName written to '$outputDirectory'";
}
Set-Alias -Name CloseDay -Value Close-Day;