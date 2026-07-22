function Resolve-Tokens {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline = $true)]
        [string]$Content,
        [Parameter(Position = 1)]
        [string]$Token = "",
        [Parameter(Position = 2)]
        [string]$Value = "",
        [Parameter(Position = 3)]
        [hashtable]$Values = $null
    )
    begin {
        $tokenKey = "";
        if ($Token.Trim() -ne "") {
            $tokenKey = "#{$Token}#";
        }
    }
    process {
        if ($null -eq $Values -and $Token -eq "") {
            return $Content;
        }
        if ($null -ne $Values) {
            foreach ($key in $Values.Keys) {
                $value = $Values[$key];
                Write-Host "$key : $value";
                $Content = $Content.Replace("#{$key}#", $value);
            }
        }
        if ($Token -ne "") {
            $Content = $Content.Replace($tokenKey, $Value);
        }
        return $Content;
    }
}
