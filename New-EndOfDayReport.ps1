function New-EndOfDayReport {
    param(
        [DateTime]$Date = (Get-Date)
    )
    $tasksFolder = Get-TaskFolder;   
    $archiveFolder = Join-Path $tasksFolder -ChildPath "archive";
    $timestamp = $Date.ToString("yyyy-MM-dd");
    $morningTaskFile = Get-Item -Path "$tasksFolder\Morning-$timestamp.tasks";
    $midDayTaskFile = Get-Item -Path "$tasksFolder\Midday-$timestamp.tasks";
    $endOfDayTaskFile = Get-Item -Path "$tasksFolder\EndOfDay-$timestamp.tasks";
    $reportFile = "$tasksFolder\Summary-$timestamp.md";
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
    $reportContent = "# Daily Task Report $timestamp`n";
    $reportContent += "`n## Morning Tasks - $timestamp`n";
    $reportContent += (Get-Content $morningTaskFile -Raw);
    $reportContent += "`n## Midday Tasks - $timestamp`n";
    $reportContent += (Get-Content $midDayTaskFile -Raw);
    $reportContent += "`n## End of Day Tasks - $timestamp`n";
    $reportContent += (Get-Content $endOfDayTaskFile -Raw);
    $reportContent += "`n";
    Move-Item $morningTaskFile.FullName -Destination (Join-Path $archiveFolder -ChildPath $morningTaskFile.Name);
    Move-Item $midDayTaskFile.FullName -Destination (Join-Path $archiveFolder -ChildPath $midDayTaskFile.Name);
    Move-Item $endOfDayTaskFile.FullName -Destination (Join-Path $archiveFolder -ChildPath $endOfDayTaskFile.Name);
    Set-Content -Path $reportFile -Value $reportContent;
    & nano $reportFile;    
    & pandoc $reportFile -o $outputFile --template eisvogel | Out-Null;
    $output = Get-Item $outputFile;
    $destination = Join-Path "\\as1\devel\Scott\DailyTasks" -ChildPath $output.Name;
    Copy-Item -Path $output.FullName -Destination $destination | Out-Null;
    Write-Host ($output.Name + " copied to '$destination'");
}
Set-Alias -Name Close -Value New-EndOfDayReport;
Set-Alias -Name CloseDay -Value New-EndOfDayReport;
Set-Alias -Name TaskReport -Value New-EndOfDayReport;
Set-Alias -Name Report -Value New-EndOfDayReport;