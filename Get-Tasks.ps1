function Get-Tasks {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param(
        [Parameter(ParameterSetName = "Default")]
        [string]$Task = "",
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "TaskNames")]
        [DateTime]$Date = (Get-Date),
        [Parameter(ParameterSetName = "TaskNames")]
        [switch]$TaskNames
    )
    $taskFolder = Get-TaskFolder;
    if ($TaskNames) {
        $result = @();
        foreach ($file in Get-ChildItem -Path $taskFolder -Filter "*$timestamp.*.md" -File) { 
            $taskName = $file.Name.Split("-")[0];
            if ($result -notcontains $taskName) {
                $result += $taskName;
            }
        }
        return $result;
    }
    $timestamp = $Date.ToString("yyyy-MM-dd");

    return Get-ChildItem -Path $taskFolder -Filter "$Task*$timestamp.*.md" | Sort-Object LastWriteTime;
}