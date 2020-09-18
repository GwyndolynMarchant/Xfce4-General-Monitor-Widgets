#!/bin/bash
# Get the current number of feed items and output them
# Requirements
#	jq: https://stedolan.github.io/jq/
#	dirname, realpath, awk, curl
#
# Requires a seperate rss-auth file that contains the following fields:
#	greader;$URL	// root of greader-compliant feed reader
#	email;$EMAIL 	// user used to login to service
#	passwd;$PASSWD 	// password used for api
#
# You can set _PATH below to a different directory if you wish to store
# your RSS credentials elsewhere

_PATH=`dirname $(realpath $0)`

# Use xdg-open if no default browser is set. Change this to your fav
if [[ $BROWSER == '' ]]; then
	BROWSER="xdg-open"
fi

URL=`awk -F ';' 'FNR==1 {print $2}' $_PATH/rss-auth`
EMAIL=`awk -F ';' 'FNR==2 {print $2}' $_PATH/rss-auth`
PASSWD=`awk -F ';' 'FNR==3 {print $2}' $_PATH/rss-auth`

LOGIN_URL="$URL/api/greader.php/accounts/ClientLogin?Email=${EMAIL}&Passwd=${PASSWD}"

auth=`curl "${LOGIN_URL}" | awk -F '=' 'NR==1{print $2}'`

num=`curl -s -H "Authorization:GoogleLogin auth=${auth}" \
  "$URL/api/greader.php/reader/api/0/unread-count?output=json" | jq '.max'`

n_color=""

if [[ num -gt 500 ]]; then
	n_color="Light Coral"
elif [[ num -gt 150 ]]; then
	n_color="khaki"
else
	n_color="white"
fi

echo "<txt> <span color='orange' size='x-large'></span> <span rise='3000' color=\"$n_color\">$num</span> </txt>"
echo "<tool>$num unread items</tool>"
echo "<click>$BROWSER 'https://rss.shadenexus.com'</click>"
echo "<txtclick>$BROWSER 'https://rss.shadenexus.com'</txtclick>"
