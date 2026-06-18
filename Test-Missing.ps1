function Test-Missing {
    param(
        [Parameter(Mandatory, ParameterSetName = "Pipe", Position = 1, ValueFromPipeline = $true)]
        [System.IO.FileInfo]$Object,
        [Parameter(Mandatory, ParameterSetName = "String", Position = 1)]
        [string]$Path
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq "Pipe") {
            $Path = $Object.FullName;
        }
        return (Test-Path -Path $Path) -eq $false;
    }
}
