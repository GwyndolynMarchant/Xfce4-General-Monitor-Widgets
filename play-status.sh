#!/bin/bash
# Display now-playing information
# Requires:
#	playerctl: https://github.com/altdesktop/playerctl

# WARNING: Playerctl does not currently play nice with chromium, and the widget will flat
# ignore all instances. This was specifically causing issues with Discord

PLAYCONTROL="playerctl --ignore-player=chromium"

# WARNING: Recent errors in arch have started producing dbus errors when no player is present.
# Temporary fix by redirecting errors to null


PLAYERSTATUS=`$PLAYCONTROL status 2>&-`

PLAY_SYM='⏹️'

if [[ $PLAYERSTATUS == 'Playing' ]]; then
	PLAY_SYM='▶️'
elif [[ $PLAYERSTATUS == 'Paused' ]]; then
	PLAY_SYM='⏸️'
else
	# exit if nothing is playing
	echo "<txt> ⏹️  </txt>"
	echo "<tool>No player connected</tool>"
	echo "<txtclick></txtclick>"

	exit
fi

PLAYERNAME=`$PLAYCONTROL metadata -f '{{playerName}}'`

NOWPLAY=''

# Get stream title info from cmus
if [[ $PLAYERNAME == 'cmus' ]]; then
	NOWPLAY=`$PLAYCONTROL metadata -f '{{cmus:stream_title}}'`
fi

# Fill in Now Playing information with defaults if nothing else found
if [[ $NOWPLAY == '' ]]; then
	NOWPLAY=`$PLAYCONTROL metadata -f '{{artist}} - {{title}}'`
fi

LENGTH=`$PLAYCONTROL metadata -f '{{mpris:length}}'`

# If a stream is running it will be 
if [[ $LENGTH -lt 0 ]]; then
	LENGTH=''
else
	LENGTH=`$PLAYCONTROL metadata -f '/{{duration(mpris:length)}}'`
fi

STATUS_TEXT=`$PLAYCONTROL metadata -f "$NOWPLAY $PLAY_SYM {{ duration(position) }}$LENGTH"`

echo "<txt> <span bgcolor='#0A84FF'> $PLAYERNAME </span><span bgcolor='#1C1C1E'> $STATUS_TEXT </span> </txt>"
echo "<tool>$PLAYERSTATUS $NOWPLAY on $PLAYERNAME</tool>"
echo "<txtclick>playerctl play-pause</txtclick>"
