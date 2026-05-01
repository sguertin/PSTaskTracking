function Invoke-TextEditor {
    param(
        [Parameter(Mandatory, ParameterSetName = "Path")]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter(Mandatory, ParameterSetName = "Pipe", ValueFromPipeline = $true)][System.IO.FileInfo]$File        
    )
    $editor = $Settings.Editor;
    if ($PSCmdlet.ParameterSetName -eq "Pipe") {
        $Path = $File.FullName;
    }
    Invoke-Expression "$editor `"$Path`"";
}