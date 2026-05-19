function Test-TaskList {
    [CmdletBinding()]
    param(
        [ValidateSet("Morning", "Midday", "EndOfDay")]
        [Parameter(Mandatory, Position = 1)][string]$TaskList,
        [Parameter(Position = 2)][datetime]$Date = (Get-Date)
    )
    $lists = @{
        "Morning"  = "morning";
        "Midday"   = "midday";
        "EndOfDay" = "end of day";
    }
    $templateFile = Get-Item (Join-Path -Path (Get-TemplatesFolder) -ChildPath "$TaskList.md" );
    $taskFile = Get-TaskList -TaskList $TaskList -Date $Date;
    $listName = $lists[$TaskList];
    if ($null -eq $taskFile) {
        Write-PSWarning "Gotta start your $listName tasks!";
        return $false;
    }
    $templateContent = Get-Content $templateFile -Raw;
    $taskContent = Get-Content $taskFile -Raw;
    if ($templateContent -eq $taskContent) {
        Write-PSWarning "Gotta finish your $listName tasks!";
        return $false
    }
    return $true;
}