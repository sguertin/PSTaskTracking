function Get-TemplatesFolder {
    return Join-Path (Get-TaskFolder) -ChildPath "templates";
}