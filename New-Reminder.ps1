function New-Reminder {
    [cmdletBinding()]
    param(
        [string]$Reminder,
        [DateTime]$Date,    
        [switch]$Day
    )
    $reminderDirectory = Get-ReminderFolder;
    $timestamp = $Date.ToString("yyyy-MM-dd")
    if ($Day -eq $true) {
        $Date = Get-Date $timestamp
    }
    
    $id = 1;
    $content = @{
        Id         = $id
        Reminder   = $Reminder
        Date       = $Date
        Resolution = $null
    };
    
    $filePath = Join-Path -Path $reminderDirectory -ChildPath "reminder-$timestamp.$id.json";    
    while (Test-Path -Path $filePath) {
        $id += 1;        
        $content.Id = $id
        $filePath = Join-Path -Path $reminderDirectory -ChildPath "reminder-$timestamp.$id.json";        
    }
    $content = $content | ConvertTo-Json;
    New-Item -Path $filePath -ItemType File -Value $content -Force | Out-Null;
}
Set-Alias -Name reminder -Value New-Reminder;
