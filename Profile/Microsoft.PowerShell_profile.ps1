Import-Module PSTaskTracking;

[scriptblock]$PrePrompt = {
    $realLASTEXITCODE = $LASTEXITCODE;
    Test-Reminders -SilentAllClear;
    Test-TaskLists;
    $global:LASTEXITCODE = $realLASTEXITCODE;
};
[scriptblock]$HomePrompt = {};
[scriptblock]$PostPrompt = {};
[scriptblock]$Prompt = {
    $realLASTEXITCODE = $LASTEXITCODE;
    $Host.UI.RawUI.WindowTitle = Split-Path $PWD.ProviderPath -Leaf
    PrePrompt | Write-Host -NoNewline; 
    Write-Host "PS $PWD>" -NoNewline -ForegroundColor Gray;
    PostPrompt | Write-Host -NoNewline;
    $global:LASTEXITCODE = $realLASTEXITCODE;
    return " "
};
Set-Item -Path function:\PrePrompt -Value $PrePrompt -Options Constant;
Set-Item -Path function:\HomePrompt -Value $HomePrompt -Options Constant;
Set-Item -Path function:\PostPrompt -Value $PostPrompt -Options Constant;
Set-Item -Path function:\prompt -Value $Prompt -Options ReadOnly;
