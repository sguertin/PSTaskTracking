function Get-DefaultTaskTrackerSettings {
    [CmdletBinding()]
    param()

    return @{
        Editor               = "micro";
        EditorCommand        = "& `"#{Editor}#`" `"#{Path}#`"";
        Morning              = @{
            Hour   = 0;
            Minute = 0;
        };
        Midday               = @{
            Hour   = 12;
            Minute = 0;
        };
        EndOfDay             = @{
            Hour   = 15;
            Minute = 0;
        };
        Report               = @{
            Hour   = 15;
            Minute = 30;
        };
        MarkdownToPdfCommand = "pandoc `"#{input}#`" -o `"#{output}#`" --template eisvogel";
        OutputDirectory      = "";
        TicketUrl            = "";
    };
}
