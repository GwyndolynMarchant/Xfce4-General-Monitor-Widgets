#!/bin/bash
# Todoist task count widget, using todoist-cli, to show how many tasks remain today
# Requirements:
#	todoist (cli): https://github.com/sachaos/todoist

list_tasks=`todoist s; unbuffer todoist --csv --color l -f '(overdue|today)' | awk -F ',' '{print "<tr><td font-weight=\"bold\">",$4,"</td><td>",$5,"</td><td>",$6,"</td></tr>"}'`
num_tasks=`echo "$list_tasks" | wc -l`

n_color="white"

if [[ num -gt 8 ]]; then
	n_color="Light Coral"
elif [[ num -gt 3 ]]; then
	n_color="khaki"
fi

echo "<txt> <span color='Orange Red' size='x-large'></span> <span rise='3000' color=\"$n_color\">$num_tasks</span> </txt>"
echo "<tool><table font-weight='light'>$list_tasks</table></tool>"
echo "<txtclick>firefox 'https://todoist.com/app'</txtclick>"