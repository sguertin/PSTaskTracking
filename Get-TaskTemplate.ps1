function Get-TaskTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Task
    )
    $templatePath = Get-TemplatesFolder | Join-Path -ChildPath $Task; 
    if (Test-Path $templatePath) {
        return Get-Item $templatePath;
    }
    return $null
}