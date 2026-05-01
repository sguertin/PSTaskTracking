function Test-Task {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ParameterSetName = "Pipe", ValueFromPipeline = $true)][System.IO.FileInfo]$TaskFile
    )
    begin {
        $task = $TaskFile.Name.Split("-")[0];
    }
    process {
        $taskTemplate = Get-TaskTemplate -Task $task;
        if ($null -eq $taskTemplate) {
            Write-Host "Cannot find a base task for $task!" -ForegroundColor Red;
            return $false;
        }
        $taskContent = (Get-Content $TaskFile)
        $templateContent = (Get-Content $taskTemplate)
        $templateContent[0] = $taskContent[0];
        if ($taskContent[2].StartsWith("### ")) {
            $templateContent[2] = $taskContent[2];
        }
        return ($templateContent.ToString() -eq $taskContent.ToString()); 
    }
}