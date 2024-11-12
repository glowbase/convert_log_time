#!/bin/bash

# Input log file
input_file=$1
# Output log file
output_file="auth_converted.log"

# Read the input file line by line
while IFS= read -r line; do
    # Extract date and time using grep
    if echo "$line" | grep -qE '^[A-Za-z]{3} [ ]*[0-9]{1,2} [0-9]{2}:[0-9]{2}:[0-9]{2}'; then
        date_part=$(echo "$line" | awk '{print $1, $2}')
        time_part=$(echo "$line" | awk '{print $3}')

        # Combine date and time for conversion
        datetime="$date_part $time_part"

        # Convert to UTC (subtract 10 hours)
        utc_time=$(date -d "$datetime AEST -10 hours" +"%b %d %H:%M:%S")

        # Replace the original date and time with the converted one
        converted_line="${line//$date_part $time_part/$utc_time}"
        
        # Output the converted line to the output file
        echo "$converted_line" >> "$output_file"
    else
        # If the line doesn't match, just write it as is
        echo "$line" >> "$output_file"
    fi
done < "$input_file"

echo "Conversion complete. Output saved to $output_file."
