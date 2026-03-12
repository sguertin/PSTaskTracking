$ScriptsDirectory = Join-Path $HomeDirectory -ChildPath "Scripts";
if (Test-Path $ScriptsDirectory) {
    $scripts = Get-ChildItem $ScriptsDirectory -Filter "*ps1";
    foreach ($script in $scripts) {
        . $script.FullName;
    }
    Write-Host ("Loaded " + $scripts.Length.ToString() + " scripts into session from: $ScriptsDirectory");
}

[scriptblock]$PrePrompt = {    
    Test-Reminders -SilentAllClear;
    Test-TaskLists;
    $CWD = $PWD.ProviderPath;
    $Host.UI.RawUI.ForegroundColor = "White"
    Write-Host "pwsh" -NoNewline -ForegroundColor White;
    Write-Host " $CWD" -NoNewline -ForegroundColor Blue;    
};
[ScriptBlock]$HomePrompt = {};
[scriptBlock]$PostPrompt = {};
[ScriptBlock]$Prompt = {
    $realLASTEXITCODE = $LASTEXITCODE;
    $Host.UI.RawUI.WindowTitle = Split-Path $PWD.ProviderPath -Leaf 
    PrePrompt | Write-Host -NoNewline
    HomePrompt
    Write-Host "`n> " -NoNewline -ForegroundColor Gray;
    PostPrompt | Write-Host -NoNewline;
    $global:LASTEXITCODE = $realLASTEXITCODE;
    return " "
};
Set-Item -Path function:\PrePrompt -Value $PrePrompt -Options Constant;
Set-Item -Path function:\HomePrompt -Value $HomePrompt -Options Constant;
Set-Item -Path function:\PostPrompt -Value $PostPrompt -Options Constant;
Set-Item -Path function:\prompt -Value $Prompt -Options ReadOnly;




