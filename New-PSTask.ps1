function New-PSTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )
    $taskFilePath = Join-Path $script:TemplatesFolder -ChildPath "$Name.md";
    if (Test-Missing -Path $taskFilePath) {
        $content = "## $Name - #{DateTimeStamp}# `n`n1. Do the task.`n  - `n";
        New-Item -Path $taskFilePath -ItemType File -Value $content | Out-Null;
    }
    Invoke-TextEditor -Path $taskFilePath;

    return $taskFilePath;
}
Set-Alias -Name Edit-PSTask -Value New-PSTask;
