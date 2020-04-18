#!/bin/bash
# Todoist task count widget, using todoist-cli, to show how many tasks remain today
# Requirements:
#	todoist (cli): https://github.com/sachaos/todoist
#	ansifilter: https://github.com/andre-simon/ansifilter
#	unbuffer, awk, head, column

# Use firefox if no default browser is set. Change this to your fav
if [[ $BROWSER == '' ]]; then
	BROWSER="firefox"
fi

TODO_LIST=`todoist --csv --color l -f '(overdue|today)'`

if [[ $TODO_LIST -ne "" ]]; then
	list_tasks=`todoist s; unbuffer todoist --csv --color l -f '(overdue|today)'  | ansifilter -M | head -n -1 | awk -F ',' '{print "•<span font-weight=\"bold\">",$4,"</span>;",$5,";",$6}' | column -t -s ';' -o ' '`
	num_tasks=`echo "$list_tasks" | wc -l`

	n_color="white"

	if [[ num -gt 8 ]]; then
		n_color="Light Coral"
	elif [[ num -gt 3 ]]; then
		n_color="khaki"
	fi

	echo "<txt> <span color='Orange Red' size='x-large'></span> <span rise='3000' color=\"$n_color\">$num_tasks</span> </txt>"
	echo "<tool><span font_family='mono' font-weight='light' size='9000'>$list_tasks</span></tool>"
	echo "<txtclick>$BROWSER 'https://todoist.com/app'</txtclick>"
else
	echo "<txt> <span color='Orange Red' size='x-large'></span> <span rise='3000' color=\"white\">0</span> </txt>"
	echo "<tool>No tasks remaining! 😊</tool>"
	echo "<txtclick>$BROWSER 'https://todoist.com/app'</txtclick>"
fi