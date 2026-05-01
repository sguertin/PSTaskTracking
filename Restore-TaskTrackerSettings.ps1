function Restore-TaskTrackerSettings {
    [CmdletBinding()]
    param(
        [string]$Id = ""
    )
    $taskFolder = Get-TaskFolder;
    $backupFiles = Get-ChildItem -Path $taskFolder -File -Filter "settings.*.bak.json";
    if ($backupFiles.Count -eq 0) {
        Write-Host "No backup settings found, exiting" -ForegroundColor Yellow;
        return;
    }
    if ([string]::IsNullOrEmpty($Id)) {
        $options = @()
        foreach ($backupFile in $backupFiles) {
            $backupId = $backupFile.Name.Replace("settings.", "").Replace(".bak.json", "");
            $options += $backupId;
            $backupDate = $backupFile.LastWriteTime.ToString("yyyy-MM-dd hh:mm:ss");
            $backupContent = (Get-Content -Path $backupFile -Raw);
            Write-Host "Id: $backupId`nModifiedDate: $backupDate`nBackupContent:`n$backupContent";            
        }
        $Id = Read-Host "Please choose which backup to restore, [$options]";
        if ($options.Contains($Id) -eq $false) {
            Write-Error "Invalid value: $Id given! Expected [$options]";
            return;
        }        
    }
    Backup-TaskTrackerSettings;
    $settingsFilePath = Get-TaskTrackerSettingsPath;
    $restoredContent = Get-Content "settings.$Id.bak.json" -Raw;
    Set-Content -Path $settingsFilePath -Value $restoredContent;
    Sync-TaskTrackerSettings;
}