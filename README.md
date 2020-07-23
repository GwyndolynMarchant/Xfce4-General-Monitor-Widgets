# Xfce4 General Monitor Widgets

A set of widgets I've constructed for xfce4-panel, using the [General Monitor](https://docs.xfce.org/panel-plugins/xfce4-genmon-plugin) plugin, to display helpful status information with mild interactivity.

### General Requirements:
- bash
- [FontAwesome](https://fontawesome.com/) icons as provided in [Nerd Fonts](https://www.nerdfonts.com/)

## Player Status

A small player status widget which shows information from the currently-active MPRIS-compliant player.

![Screenshot of the player status widget, displaying that True Trans Soul Rebel by Against Me! is playing on cmus](.screenshots/play-status.png?raw=true)

### Requirements:
- [playerctl](https://github.com/altdesktop/playerctl)

## RSS Feeds

Queries the current number of unread items from a greader-compatible web feedreader. (Built for [FreshRSS](https://freshrss.org/).)

![Screenshot of the RSS widget showing I have 124 unread news items.](.screenshots/rss.png?raw=true)

### Requirements:
- [FreshRSS](https://freshrss.org/) or theoretically any greader-compatible feedreader, running on your server
- [jq](https://stedolan.github.io/jq/)
- dirname
- realpath
- awk
- curl

### Configuration
Create a file named `rss-auth` that contains the following fields:
```
greader;$URL	// root of greader-compliant feed reader
email;$EMAIL 	// user used to login to service
passwd;$PASSWD 	// password used for api
```

## Todoist

Displays how many tasks you have remaining for today. (Both today's and overdue tasks.) Provides a tooltip showing a summary of the tasks. 

![Screenshot of the Todoist widget, showing my daily tasks in the tooltip](.screenshots/todoist.png?raw=true)

### Requirements:
- A [Todoist](https://todoist.com) account
- [todoist (cli)](https://github.com/sachaos/todoist)
- [ansifilter](https://github.com/andre-simon/ansifilter)
- unbuffer
- awk
- head
- column