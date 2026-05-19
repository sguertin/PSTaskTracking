function Resolve-Tokens {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline = $true)]
        [string]$Content,        
        [Parameter(Mandatory, Position = 1)]
        [string]$Token,
        [Parameter(Mandatory, Position = 2)]
        [string]$Value,
        [Parameter(Position = 3)]
        [hashtable]$Values = $null
    )
    begin {
        $tokenValue = "#{$Token}#";
    }
    process {
        if ($null -ne $Values) {
            foreach ($key in $Values.keys) {
                $value = $Values[$key];
                $Content = $Content.Replace("#{$key}#", $value);
            }
        }
        return $Content.Replace($tokenValue, $Value);
    }
}