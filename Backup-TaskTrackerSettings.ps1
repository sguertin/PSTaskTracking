function Backup-TaskTrackerSettings {
    [CmdletBinding()]
    param()    
    $backupId = (Get-ChildItem -Path $script:TaskFolder -File -Filter "settings.*.bak.json").Count + 1;
    $backupFilePath = Join-Path -Path $script:TaskFolder -ChildPath "settings.$backupId.bak.json";
    while (Test-Path $backupFilePath) {
        # Are the backups out of sync? We'll just get to the highest non-existent number
        $backupId += 1;
        $backupFilePath = Join-Path -Path $script:TaskFolder -ChildPath "settings.$backupId.bak.json";
    }
    Set-Content $backupFilePath -Value (ConvertTo-Json $script:Settings);
    Write-Verbose "Backup created at '$backupFilePath'";    
}