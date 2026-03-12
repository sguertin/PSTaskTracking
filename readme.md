# PSTaskTracking

This is a homegrown task tracking system I built primarily to keep myself on top of my day to day tasks.

## Prerequisites

- [PowerShell](https://github.com/PowerShell/PowerShell), this is all designed and tested on pwsh 7.4.x but should work fine for any modern version of PowerShell, use PowerShell 5 at your own peril.
- nano (I install this via [Cygwin](https://cygwin.com/index.html) but other options do exist.)
- [pandoc](https://pandoc.org/)
- [MikTex Console](https://miktex.org/)
- [eisvogel](https://github.com/enhuiz/eisvogel)

## Getting Started

The scripts provided in here need to be 'dot sourced' into your PS session. The sample PS profile file, .\Profile\Microsoft.PowerShell_profile.ps1 illustrates how to dot source all powershell scripts from a 'Scripts' folder in your user directory (C:\Users\<USERNAME>), it also shows how to integrate the task reminders into your prompt directly. One option for setting this up is to checkout this repository into that scripts folder. The path to your local powershell profile will always be in the $PROFILE variable in your powershell session.

To initialize the whole task tracking system, run the `Initialize-PSTaskTracking` command, that will scaffold up the folders it uses for work and will create stubs for each of the main daily task lists. Feel free to edit those as you see fit, note that these three files will ultimately be concatenated into a single [Markdown](https://www.markdownguide.org/basic-syntax/) file that will then be converted to a PDF, so keeping the task lists in a Markdown compatible syntax is key.

## Daily Usage

The default time frames (based on the system local time) for each of the task list reminders is as follows:
Morning list expects to be started as soon as the day begins

Midday list expects to be started at 12PM

End of Day list expects to be started at 3PM

The close out report for the day is expected to be generated at 3:50PM

Each of these can be changed by adjusting the script `Test-TaskLists`, there are variables to specify when each task list should be done by, in military time.

The standard commands you'll use to start filling out your task list for that day have aliases (all case insensitive) for your convenience:

`Start-Day`: `morning`
`Start-Midday`: `midday`
`Start-EndOfDay`: `eod`, `endday`, `endofday`
`New-EndOfDayReport`: `closeday`, `close`, `taskreport`, `report`

Running any of these commands will drop you into a nano editor to fill out a fresh copy of the task list for that part of the day.

## Reminders

If you integrate the `Test-Reminders` function into your terminal you can also create reminders for yourself that will also appear when your prompt repaints after a command.
The following commands are available for managing reminders:

- `New-Reminder`, alias: `reminder` - creates a new reminder
- `Get-Reminders`, alias: `today` - lists all reminders pending for today
- `Get-OverdueReminders`, alias: `overdue` - lists all incomplete reminders from prior days
- `Test-Reminders`, alias: `reminders` - lists you to what reminders are due as of right now.

### Creating a Reminder

```pwsh
    # A reminder for a specific day and time
    reminder "Go eat lunch." -Date (Get-Date).AddHours(3); # This will set a reminder that will be considered 'due' 3 hours from now.
    # All day reminder - will be considered due as of 12AM of the date set
    reminder "All day training" -Date (Get-Date).AddDays(1) -Day # the -Day flag will set the reminder to midnight of the day provided
```
