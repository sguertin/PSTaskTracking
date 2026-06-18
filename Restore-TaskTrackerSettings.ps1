function Restore-TaskTrackerSettings {
    [CmdletBinding()]
    param(
        [string]$Id = ""
    )

    $backupFiles = Get-ChildItem -Path $script:TaskFolder -File -Filter "settings.*.bak.json";
    if ($backupFiles.Count -eq 0) {
        Write-PSHost "No backup settings found, exiting" -ForegroundColor Yellow -Command $MyInvocation.MyCommand;
        return;
    }
    if ([string]::IsNullOrEmpty($Id)) {
        $options = @()
        foreach ($backupFile in $backupFiles) {
            $backupId = $backupFile.Name.Replace("settings.", "").Replace(".bak.json", "");
            $options += $backupId;
            $backupDate = $backupFile.LastWriteTime.ToString($script:DateTimeStamp);
            $backupContent = (Get-Content -Path $backupFile -Raw);
            Write-PSHost "Id: $backupId`nModifiedDate: $backupDate`nBackupContent:`n$backupContent" -Command $MyInvocation.MyCommand;
        }
        $Id = Read-Host "Please choose which backup to restore, [$options]";
        if ($options.Contains($Id) -eq $false) {
            Write-PSError "Invalid value: $Id given! Expected [$options]" -Command $MyInvocation.MyCommand;
            return;
        }
    }
    Backup-TaskTrackerSettings;

    $restoredContent = Get-Content "settings.$Id.bak.json" -Raw;
    Set-Content -Path $script:SettingsFile -Value $restoredContent;
    Sync-TaskTrackerSettings;
}
