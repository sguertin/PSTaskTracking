# PSTaskTracking

This is a homegrown task tracking system I built primarily to keep myself on top of my day to day tasks.

## Prerequisites - Windows

- [PowerShell](https://github.com/PowerShell/PowerShell), this is all designed and tested on pwsh 7.4.x but should work fine for any modern version of PowerShell, use PowerShell 5 at your own peril.
- [micro](https://github.com/micro-editor/micro)
- [pandoc](https://pandoc.org/)
- [MikTex Console](https://miktex.org/) - specifically the pdfLatex package
- [eisvogel](https://github.com/enhuiz/eisvogel)

## Getting Started

Download the latest release, place the release folder into a directory on your `PSModulePath`, typical path on Windows would be `C:\Users\<UserName>\Documents\PowerShell\Modules` or `/home/<User>/.local/share/powershell/Modules` on Linux.

The first time you import the module, it will scaffold up the folders it uses for work and will create stubs for each of the main daily task lists. There are commands to edit each of the task lists: `Edit-MorningTaskList`, `Edit-MiddayTaskList`, and `Edit-EndOfDayTaskList`, note that these three files will ultimately be concatenated into a single [Markdown](https://www.markdownguide.org/basic-syntax/) file that will then be converted to a PDF, so keeping the task lists in a Markdown compatible syntax will ensure you get the best results.

## Daily Usage

The default time frames (based on the system local time) for each of the task list reminders is as follows:

Morning list expects to be started as soon as the day begins

Midday list expects to be started at 12PM

End of Day list expects to be started at 3PM

The close out report for the day is expected to be generated at 3:50PM

These can be updated by using the `Edit-TaskTrackerSettings` command. This command can also allow you to change what text editor is used, as well
as what directory to write the pdf reports, as well as what command you want to use for outputting a pdf. If you set the command to an empty string,
no pdf will be generated. The command string will render an input file path as `#{inputfile}#

The standard commands you'll use to start filling out your task list for that day have aliases (all case insensitive) for your convenience:

`Start-Day`: `Morning`

`Start-Midday`: `Midday`

`Start-EndOfDay`: `eod`, `EndDay`, `EndOfDay`

Running any of these commands will drop you into a text editor to fill out a fresh copy of the task list for that part of the day.

## Creating a Day Summary Report

The following command will execute the following steps:

1. Combine all three task files into a single markdown file
2. Launch the editor specified (default is micro) to let you edit the final report as needed
3. After exiting the editor, a pdf will be generated from the report file via pandoc and dropped in your daily tasks folder.

`New-EndOfDayReport`: `CloseDay`, `close`, `TaskReport`, `report`

### Weekly Tasks

- You can add tasks that only need to be done once a week on a particular day as well, go to the templates folder (can be retrieved via the `Get-TemplatesFolder` command). In that folder if you create a file called `DayOfWeek`.`TimeOfDay`.tasks e.g. `friday.morning.tasks`, it will automatically include the contents of that file when creating the task file for that day/time.

## Reminders

If you integrate the `Test-Reminders` function into your terminal you can also create reminders for yourself that will also appear when your prompt repaints after a command.
The following commands are available for managing reminders:

- `New-Reminder`, alias: `reminder` - creates a new reminder
- `Get-Reminders`, alias: `today` - lists all reminders pending for today
- `Get-OverdueReminders`, alias: `overdue` - lists all incomplete reminders from prior days
- `Test-Reminders`, alias: `reminders` - lists you to what reminders are due as of right now.
- `Close-Reminder`, alias: `close` - Marks a reminder as complete.

### Creating a Reminder

```pwsh
    # A reminder for a specific day and time
    reminder "Go eat lunch." -Date (Get-Date).AddHours(3); # This will set a reminder that will be considered 'due' 3 hours from now.
    # All day reminder - will be considered due as of 12AM of the date set
    reminder "All day training" -Date (Get-Date).AddDays(1) -Day # the -Day flag will set the reminder to midnight of the day provided
```

### Closing a Reminder

When a reminder is created, it will get an Id assigned to it, and a date stamp, those to values must be passed to the `Close-Reminder` command to mark the reminder as finished.

```pwsh
    close 1; # Closes reminder with id 1 for today
    close 2 -Date (Get-Date).AddDays(-1); # Closes reminder 2 from yesterday
```

### Edit Settings

The `Edit-TaskTrackerSettings` command will allow you to change what editor is invoked as well as the time frames that the alerts will pop up.
