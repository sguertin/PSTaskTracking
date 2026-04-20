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
    param()

    $reportFile = New-EndOfDayReport -Date (Get-Date);
    if ($null -eq $reportFile) {
        return;
    }
    & $env:PSTT_Editor $reportFile;
    
    if (Test-EmptyString $env:PSTT_PdfOutput) {        
        return;
    }
    if (Test-EmptyString $env:PSTT_OutputDirectory) {
        $outputDirectory = Get-TaskFolder;
    } else {
        $outputDirectory = $env:PSTT_OutputDirectory;
    }
    $outputFileName = (Split-Path -Path $reportFile -Leaf).Replace(".md", ".pdf");
    $outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName;
    $outputCommand = $env:PSTT_PdfOutput.Replace("#{input}#", "$reportFile").Replace("#{output}#", $outputFilePath);
    Invoke-Expression -Command $outputCommand | Out-Null;
    Write-Host "$outputFileName written to '$outputDirectory'";
}
Set-Alias -Name CloseDay -Value New-EndOfDayReport;