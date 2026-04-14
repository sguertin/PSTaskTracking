function New-EndOfDayReport {
    <#
    .SYNOPSIS
    Generate an end of day report
    
    .DESCRIPTION
    Concatenates together the contents of the morning, midday, and end of day task lists for the provided Date, today by default, then launches a text editor on the newly created markdown file. Upon exiting, it will generate a pdf of the file via pandoc.
    
    .PARAMETER Date
    The date to create a report for, defaults to today.
    
    .EXAMPLE
    # Generate today's report
    New-EndOfDayReport;

    # Generate a report for yesterday
    New-EndOfDayReport -Date (Get-Date).AddDays(-1);
    
    .NOTES
    Several aliases are set for your convenience, Close, CloseDay, TaskReport, and Report
    #>
    [CmdletBinding()]
    param(
        [DateTime]$Date = (Get-Date)
    )
    $tasksFolder = Get-TaskFolder;   
    $archiveFolder = Join-Path $tasksFolder -ChildPath "archive";
    $timestamp = $Date.ToString("yyyy-MM-dd");
    $morningTaskFile = Get-Item -Path (Join-Path $tasksFolder -ChildPath "Morning-$timestamp.md");
    $midDayTaskFile = Get-Item -Path (Join-Path $tasksFolder -ChildPath "Midday-$timestamp.md");
    $endOfDayTaskFile = Get-Item -Path (Join-Path $tasksFolder -ChildPath "EndOfDay-$timestamp.md");
    $reportFile = Join-Path $tasksFolder -ChildPath "Summary-$timestamp.md";
    $outputFile = $reportFile.Replace(".md", ".pdf");
    if (Test-Path $reportFile) {
        Write-Error "'$reportFile' already exists!";
        return;
    }
    if ((Test-Path $morningTaskFile) -eq $false) {
        Write-Error "Unable to find $morningTaskFile, did you forget to create it?";
        return;
    }
    if ((Test-Path $midDayTaskFile) -eq $false) {
        Write-Error "Unable to find $midDayTaskFile, did you forget to create it?";
        return;
    }
    if ((Test-Path $endOfDayTaskFile) -eq $false) {
        Write-Error "Unable to find $endOfDayTaskFile, did you forget to create it?";
        return;
    }
    $reportContent = "# Daily Task Report $timestamp`n`n";
    $reportContent += (Get-Content $morningTaskFile -Raw);
    $reportContent += "`n";
    $reportContent += (Get-Content $midDayTaskFile -Raw);
    $reportContent += "`n";
    $reportContent += (Get-Content $endOfDayTaskFile -Raw);
    $reportContent += "`n";
    Move-Item $morningTaskFile.FullName -Destination (Join-Path $archiveFolder -ChildPath $morningTaskFile.Name);
    Move-Item $midDayTaskFile.FullName -Destination (Join-Path $archiveFolder -ChildPath $midDayTaskFile.Name);
    Move-Item $endOfDayTaskFile.FullName -Destination (Join-Path $archiveFolder -ChildPath $endOfDayTaskFile.Name);
    Set-Content -Path $reportFile -Value $reportContent;
    & $env:PSTT_Editor $reportFile;    
    & pandoc $reportFile -o $outputFile --template eisvogel | Out-Null;
    $output = Get-Item $outputFile;
    $outputFileName = $output.Name;
    $destination = Join-Path (Get-TaskFolder) -ChildPath $outputFileName;
    Copy-Item -Path $output.FullName -Destination $destination | Out-Null;
    Write-Host ("$outputFileName copied to '$destination'");
}
Set-Alias -Name CloseDay -Value New-EndOfDayReport;
Set-Alias -Name TaskReport -Value New-EndOfDayReport;
Set-Alias -Name Report -Value New-EndOfDayReport;