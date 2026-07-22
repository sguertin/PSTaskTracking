function Get-DefaultData {
    param(
        [string]$Name,
        [datetime]$Date
    )

    return [hashtable]@{
        Name          = $Name;
        DateTimeStamp = $Date.ToString($script:DateTimeStamp);
        DateStamp     = $Date.ToString($script:DateStamp);
        DateString    = $Date.ToString($script:DateString)
    };
}