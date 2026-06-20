function Get-Reminders {
    <#
    .SYNOPSIS

    Retrieves all reminders for current day.

    .EXAMPLE
    Get-Reminders;
    #>
    [CmdletBinding()]
    param()
    $reminders = @()
    if (Test-Path $script:RemindersFile) {
        Get-Content $script:RemindersFile | ConvertFrom-Json | ForEach-Object {
            $reminders += $_;
        };
    } else {
        New-Item $script:RemindersFile -ItemType File -Value "[]";
    }
    return $reminders;
}
Set-Alias -Name today -Value Get-Reminders;
