function Start-Task {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [datetime]$Date = (Get-Date),
        [hashtable]$Data = $null
    )
    $timestamp = $Date.ToString($script:DateStamp)
    $templatePath = Join-Path $script:TemplatesFolder -ChildPath "$Name.md";
    if (Test-Missing -Path $templatePath) {
        Write-PSError "Could not find template for task $Name!"
    }
    $DefaultData = @{ Name = $Name; $DateTimeStamp = $Date.ToString($script:DateTimeStamp); };
    # By having the parameter data resolve first, ensures user supplied data always takes precedence over defaults.
    $content = Get-Content $templatePath -Raw | Resolve-Tokens -Values $Data | Resolve-Tokens -Values $DefaultData;
    $taskId = (Get-ChildItem $script:TaskFolder -Filter "$Name-$timestamp.*.md").Count + 1;
    $taskFilePath = Join-Path $script:TaskFolder -ChildPath "$Name-$timestamp.$taskId.md";

    New-Item -Path $taskFilePath -ItemType File -Value $content;
    
    Invoke-TextEditor -Path $taskFilePath;
}
Set-Alias -Name Task -Value Start-Task;
