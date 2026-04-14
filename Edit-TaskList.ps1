function Edit-TaskList {
    [CmdletBinding()]
    param(
        [ValidateSet("Morning", "morning", "Midday", "midday", "endofday", "EndOfDay")]
        [Parameter(Mandatory, Position = 1)][string]$TaskList
    )
    $filePath = Join-Path (Get-TemplatesFolder) -ChildPath ("$TaskList.md".ToLower())
    & $env:PSTT_Editor $filePath;
}