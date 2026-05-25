function Get-WorkDayLogs {
    [CmdletBinding()]
    param(
        [datetime]$Date
    )
    $dateStamp = $Date.ToString($script:DateStamp);
    $logs = @();
    
    foreach ($taskList in @("Morning", "Midday", "EndOfDay")) {        
        $filePath = Join-Path $script:TaskFolder -ChildPath ("$taskList-$dateStamp.md");
        if (Test-Path $filePath) {
            $file = Get-Item -Path $filePath;
            $logs.Add(@{
                    Path          = $file.FullName;
                    ArchivePath   = (Join-Path $script:ArchiveFolder -ChildPath $file.Name);
                    LastWriteTime = $file.LastWriteTime;    
                });
        } else {
            Write-PSError "Could not find $taskList tasks for $dateStamp!";
            return $null;
        }
    }
    Get-ChildItem $script:TaskFolder -Filter "*-$dateStamp.*.md" | ForEach-Object {  
        $logs.Add(@{
                Path          = $_.FullName;
                ArchivePath   = (Join-Path $script:ArchiveFolder -ChildPath $_.Name);
                LastWriteTime = $_.LastWriteTime;    
            }); 
    }    
    return $logs | Sort-Object LastWriteTime;
}