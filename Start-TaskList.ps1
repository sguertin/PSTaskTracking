function Start-TaskList {
    <#
    .SYNOPSIS
    Starts the specified task list
    
    .DESCRIPTION
    Creates a copy of the specified task template and launches the text editor to begin filling it out
    
    .PARAMETER TaskList
    The task list to create, expects Morning, Midday, or EndOfDay
    
    .EXAMPLE
    Start-TaskList "Morning";
    
    Start-TaskList -TaskList "Midday";
    #>
    [CmdletBinding()]
    param(
        [ValidateSet("Morning", "Midday", "EndOfDay")]
        [Parameter(Mandatory, Position = 1)][string]$TaskList,
        [datetime]$Date = (Get-Date)
    )
    $taskTemplate = Join-Path $script:TemplatesFolder -ChildPath "$TaskList.md";    
    $timestamp = $Date.ToString($script:DateStamp);
    $taskFilePath = Join-Path $script:TaskFolder -ChildPath "$TaskList-$timestamp.md";
    if (Test-Missing $taskFilePath) {        
        Copy-Item $taskTemplate -Destination $taskFilePath;    
        $dayOfWeek = $Date.DayOfWeek.ToString();    
        $dailyTasks = Join-Path $script:TemplatesFolder -ChildPath "$dayOfWeek.$TaskList.md";
        if (Test-Path $dailyTasks) {
            $content = Get-Content $taskFilePath;
            $content += "`n### $dayOfWeek Tasks `n"
            $content += Get-Content $dailyTasks -Raw;
            Set-Content $taskFilePath -Value $content
        }
    }
    Invoke-TextEditor -Path $taskFilePath;
}
