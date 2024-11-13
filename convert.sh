#!/bin/bash

LOG_FILE="$1"
HEADERS="Date/Time,IP Address,HTTP Method,URI,Status Code,Bytes,Referrer,User Agent"

log_lines=$(cat "$LOG_FILE")
lines="$HEADERS\n"

while IFS= read -r line; do
    ip=$(echo "$line" | cut -d " " -f 1)
    time=$(echo "$line" | cut -d " " -f 4-5 | sed  's/\[//g' | sed 's/\]//g')
    method=$(echo "$line" | cut -d " " -f 6 | sed 's/"//g')
    uri=$(echo "$line" | cut -d " " -f 7)
    code=$(echo "$line" | cut -d " " -f 9)
    bytes=$(echo "$line" | cut -d " " -f 10)
    referrer=$(echo "$line" | cut -d " " -f 11)
    user_agent=$(echo "$line" | cut -d " " -f 12-20)

    month=$(echo "$time" | sed -E 's/(Jan)/01/; s/(Feb)/02/; s/(Mar)/03/; s/(Apr)/04/; s/(May)/05/; s/(Jun)/06/; s/(Jul)/07/; s/(Aug)/08/; s/(Sep)/09/; s/(Oct)/10/; s/(Nov)/11/; s/(Dec)/12/')
    
    formatted_date=$(echo "$month" | cut -d ":" -f 1 | sed -E 's#([0-9]{2})/([0-9]{2})/([0-9]{4})#\3-\2-\1#')
    formatted_time=$(echo "$time" | cut -d ":" -f 2-5)
    utc_time=$(date -d "$formatted_date $formatted_time" -u +"%Y-%m-%dT%H:%M:%SZ")

    lines+="$utc_time,$ip,$method,$uri,$code,$bytes,$referrer,$user_agent\n"
done <<< "$log_lines"

echo -e "$lines" >> "$LOG_FILE.csv"