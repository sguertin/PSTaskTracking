function Get-TaskFolder {
    $userDirectory = $env:USERPROFILE
    return Join-Path $userDirectory -ChildPath "DailyTasks"
}