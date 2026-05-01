function New-TaskTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)][string]$Task
    )
    
    $filePath = Join-Path -Path (Get-TemplatesFolder) -ChildPath "$Task.md";
    if ((Test-Path $filePath) -eq $false) {
        New-Item -Path $filePath -ItemType File -Value "## $Task - {timestamp}`n`n{name}`n`n";    
    }
    return Get-Item -Path $filePath;    
}