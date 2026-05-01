function Start-Task {
    <#
    .SYNOPSIS
    Creates a copy of the specified Task for the date specified and launches editor after copying the template
    
    .DESCRIPTION
    This command will create a copy of the template file named for the Task parameter passed in, and place the copy in the app
    working directory with the month timestamp and launch the defined editor for that file. 

    .PARAMETER Task
    The task to run the editor for
    
    .PARAMETER Date
    The date for the task (defaults to today)

    .PARAMETER Name
    The name, if any, for this particular instance of the task. Defaults to ""    
    
    .EXAMPLE
    Start-Task DailyReport
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)][string]$Task,
        [Parameter(Position = 2)][DateTime]$Date = (Get-Date),
        [Parameter(Position = 3)][string]$Name = ""
    )

    $taskTemplate = Join-Path (Get-TemplatesFolder) -ChildPath "$Task.md";
    if ((Test-Path -Path $taskTemplate) -eq $false) {
        Write-Error "Could not find a template for $Task!";
        return;
    }
    $timestamp = $Date.ToString("yyyy-MM-dd");
    $tasksFolder = Get-TaskFolder;
    $id = 1;
    $taskFilePath = Join-Path $tasksFolder -ChildPath "$Task-$timestamp.$id.md";
    while (Test-Path $taskFilePath) {
        $id += 1;
        $taskFilePath = Join-Path $tasksFolder -ChildPath "$Task-$timestamp.$id.md";
    }
    if ((Test-Path $taskFilePath) -eq $false) {        
        Copy-Item $taskTemplate -Destination $taskFilePath;
    }
    if ([string]::IsNullOrEmpty($Name) -eq $false) {
        $Name = "### $Name";        
    }
    $content = (Get-Content $taskFilePath -Raw).Replace("{timestamp}", $timestamp).Replace("{name}", "$Name");     
    Set-Content $taskFilePath -Value $content;
    & $script:Settings.Editor $taskFilePath;
}
Set-Alias -Name task -Value Start-Task;