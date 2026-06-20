function Test-Missing {
    param(
        [Parameter(ParameterSetName = "Pipe", Position = 1, ValueFromPipeline = $true)]
        [System.IO.FileInfo]$Object,
        [Parameter(ParameterSetName = "String", Position = 1)]
        [string]$Path
    )
    process {
        if ($null -eq $Object -and $null -eq $Path) {
            return $true;
        }
        if ($PSCmdlet.ParameterSetName -eq "Pipe") {
            $Path = $Object.FullName;
        }
        return (Test-Path -Path $Path) -eq $false;
    }
}
