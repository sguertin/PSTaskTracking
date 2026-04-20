function Test-EmptyString {
    [CmdletBinding()]
    param(
        [AllowNull()][Parameter(Mandatory)][string]$Value
    )
    return [string]::IsNullOrEmpty($Value);
}