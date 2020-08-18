#!/bin/bash
# Display now-playing information
# Requires:
#	playerctl: https://github.com/altdesktop/playerctl

# Colors

PLAYER_BG='#1D72E9'
PLAYER_FG='#C0C0C0'
TEXT_BG='#E0DEE1'

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
	NOWPLAY=`$PLAYCONTROL metadata -f '👤 {{artist}} 🖭 {{title}}'`
else
	NOWPLAY="📻 $NOWPLAY"
fi

LENGTH=`$PLAYCONTROL metadata -f '{{mpris:length}}'`
DURATION=''

# If a stream is running it will be 
if [[ $LENGTH -lt 0 ]]; then
	LENGTH=''
elif [[ $LENGTH != '' ]]; then
	LENGTH=`$PLAYCONTROL metadata -f '/{{duration(mpris:length)}}'`
	DURATION=`$PLAYCONTROL metadata -f '{{duration(position)}}'`
fi

STATUS_TEXT=`$PLAYCONTROL metadata -f "$NOWPLAY $PLAY_SYM $DURATION$LENGTH"`

echo "<txt> <span bgcolor='$PLAYER_BG' fgcolor='$PLAYER_FG'> $PLAYERNAME </span><span bgcolor='$TEXT_BG'> $STATUS_TEXT </span> </txt>"
echo "<tool>$PLAYERSTATUS $NOWPLAY on $PLAYERNAME</tool>"
echo "<txtclick>$PLAYCONTROL play-pause</txtclick>"
