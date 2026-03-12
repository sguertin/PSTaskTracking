function Start-EndOfDay {
    Start-TaskList "EndOfDay";
}
Set-Alias -Name EndDay -Value Start-EndOfDay;
Set-Alias -Name eod -Value Start-EndOfDay;
Set-Alias -Name EndOfDay -Value Start-EndOfDay;