function Invoke-TextEditor {
    [CmdletBinding()]
    param(
        [string]$Path
    )
    $command = [string]::IsNullOrEmpty($script:Settings.EditorCommand) ? "& `"#{Editor}#`" `"#{Path}#`"" : $script:Settings.EditorCommand;
    $command = $command | Resolve-Tokens -Values @{ Editor = $script:Settings.Editor; Path = $Path }
    Invoke-Expression $command;
}
