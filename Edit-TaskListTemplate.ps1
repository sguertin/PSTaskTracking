function Edit-TaskListTemplate {
    [CmdletBinding()]
    param(
        [ValidateSet("Morning", "Midday", "EndOfDay")]
        [Parameter(Mandatory, Position = 1)][string]$TaskList
    )
    $filePath = Join-Path (Get-TemplatesFolder) -ChildPath ("$TaskList.md")
    Invoke-TextEditor -Path $filePath;
}