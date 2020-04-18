#!/bin/bash
# Display now-playing information
# Requires:
#	playerctl: https://github.com/altdesktop/playerctl

PLAYERSTATUS=`playerctl status`

PLAY_SYM='⏹️'

if [[ $PLAYERSTATUS == 'Playing' ]]; then
	PLAY_SYM='▶️'
elif [[ $PLAYERSTATUS == 'Stopped' ]]; then
	PLAY_SYM='⏸️'
else
	# exit if nothing is playing
	exit
fi

PLAYERNAME=`playerctl metadata -f '{{playerName}}'`

NOWPLAY=''

# Get stream title info from cmus
if [[ $PLAYERNAME == 'cmus' ]]; then
	NOWPLAY=`playerctl metadata -f '{{cmus:stream_title}}'`
fi

# Fill in Now Playing information with defaults if nothing else found
if [[ $NOWPLAY == '' ]]; then
	NOWPLAY=`playerctl metadata -f '{{artist}} - {{title}}'`
fi

LENGTH=`playerctl metadata -f '{{mpris:length}}'`

# If a stream is running it will be 
if [[ $LENGTH -lt 0 ]]; then
	LENGTH=''
else
	LENGTH=`playerctl metadata -f '/{{duration(mpris:length)}}'`
fi

STATUS_TEXT=`playerctl metadata -f "$NOWPLAY $PLAY_SYM {{ duration(position) }}$LENGTH"`

if [[ $STATUS_TEXT == '' ]]; then
	echo "<txt> ⏹️  </txt>"
	echo "<tool>No player connected</tool>"
	echo "<txtclick></txtclick>"
else
	echo "<txt> <span bgcolor='#0A84FF'> $PLAYERNAME </span><span bgcolor='#1C1C1E'> $STATUS_TEXT </span> </txt>"
	echo "<tool>$PLAYERSTATUS $NOWPLAY on $PLAYERNAME</tool>"
	echo "<txtclick>playerctl play-pause</txtclick>"
fi