function Get-DefaultTaskTrackerSettings {
    [CmdletBinding()]
    param()

    return [hashtable]@{
        Editor               = "micro";
        EditorCommand        = "& `"#{Editor}#`" `"#{Path}#`"";
        EnableReminders      = $true;
        EnableTaskLists      = $true;
        Morning              = [hashtable]@{
            Hour   = 0;
            Minute = 0;
        };
        Midday               = [hashtable]@{
            Hour   = 12;
            Minute = 0;
        };
        EndOfDay             = [hashtable]@{
            Hour   = 15;
            Minute = 0;
        };
        Report               = [hashtable]@{
            Hour   = 15;
            Minute = 30;
        };
        MarkdownToPdfCommand = "pandoc `"#{input}#`" -o `"#{output}#`" --template eisvogel";
        OutputDirectory      = "";
        TicketUrl            = "";
    };
}
