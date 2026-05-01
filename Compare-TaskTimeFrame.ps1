function Compare-TaskTimeFrame {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline = $true)]
        [System.IO.FileInfo]$TaskFile,
        [int]$BeforeHour = 23,
        [int]$BeforeMinute = 59,
        [float]$BeforeTime = $null,
        [int]$AfterHour = 0,
        [int]$AfterMinute = 0,
        [float]$AfterTime = $null
    )
    begin {
        if ($null -eq $BeforeTime -and $null -eq $AfterTime) {            
            if ($BeforeHour -eq $AfterHour) {
                Write-Error "Cannot have Before and After times be equal."
            }
            $BeforeTime = $BeforeHour + ($BeforeMinute / 60);
            $AfterTime = $AfterHour + ($AfterMinute / 60);      
        }  
    }
    process {
        $time = ConvertTo-TimeValue -Hour $TaskFile.LastWriteTime.Hour -Minute $TaskFile.LastWriteTime.Minute;
        if ($time -gt $AfterTime -and $time -le $BeforeTime) {
            return $TaskFile;
        }
        return;    
    }
}