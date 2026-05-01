function Edit-TaskTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)][string]$Task
    )
    $template = Get-TaskTemplate -Task $Task;
    if ($null -eq $template) {
        $template = New-TaskTemplate -Task $Task;
    }    
    Invoke-TextEditor -Path $template.FullName;
}