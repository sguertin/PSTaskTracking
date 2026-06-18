function Confirm-TaskCompletion {
    [CmdletBinding()]
    param(
        [System.IO.FileInfo]$TaskFile
    )
    # File Name format for both task lists and tasks follows: "{Name}-{timestamp}...";
    $TemplateName = $TaskFile.Name.Split("-")[0];
    $Content = (Get-Content $TaskFile.FullName -Raw);
    $TemplateContent = (Get-Content (Join-Path $script:TemplatesFolder -ChildPath "$TemplateName.md"));
    # If the task file still matches the template, it's not complete
    # TODO Handle Rendered values somehow? Maybe just take the L?
    return $Content -ne $TemplateContent;
}
