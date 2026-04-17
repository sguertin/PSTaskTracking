function Add-PrePromptToPoshGit {
    <#
    .SYNOPSIS
    Updates the oh-my-posh start up script to include the existing PrePrompt    
    #>
    [CmdletBinding()]
    param()

    $ohMyPoshDirectory = Join-Path -Path $env:LOCALAPPDATA -ChildPath "oh-my-posh";
    foreach ($script in Get-ChildItem $ohMyPoshDirectory -Filter "*ps1") {
        $content = Get-Content $script -Raw;
        Set-Content -Path $script -Value $content.Replace("`$promptFunction = {", "`$promptFunction = {`n        PrePrompt | Write-Host -NoNewline;");
    }
}