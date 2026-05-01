function Get-FinishedTasks {
    [CmdletBinding()]
    param(
        [datetime]$Date = (Get-Date)
    )
    $taskLists 
    $timestamp = $Date.ToString("yyyy-MM-dd");
    return Get-ChildItem -Path $taskFolder -Filter "*$timestamp*md" | Sort-Object LastWriteTime;
}