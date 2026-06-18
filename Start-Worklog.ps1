function Start-WorkLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Task,
        [string]$Ticket = "",
        [string]$Time = "0 hrs",
        [datetime]$Date = (Get-Date),
        [hashtable]$Data = $null
    )
    if ([string]::IsNullOrEmpty($Ticket) -eq $false) {
        if ([string]::IsNullOrEmpty($script:TicketUrl) -eq $false) {
            $Ticket = "[$Ticket]($TicketUrl/$Ticket)";
        }
        $Ticket = "Ticket: $Ticket - ";
    }
    $workLogData = @{
        Name          = $Task;
        DateTimeStamp = $Date.ToString($script:DateTimeStamp);
        Ticket        = $Ticket;
        Time          = $Time;
    }
    if ($null -ne $Data) {
        foreach ($key in $Data.Keys) {
            $workLogData[$key] = $Data[$key];
        }
    }
    Start-Task -Name "WorkLog" -Date $Date -Data $workLogData;
}
Set-Alias -Name WorkLog -Value Start-WorkLog;
Set-Alias -Name wl -Value Start-WorkLog;
