#!/bin/bash

# This script will scan the IP address range specified and display the IP address and hostname
# of any active hosts.

for ip in $(seq 1 254); do
	ping -c 1 insert your ip here .$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
	# Write the output of the ping command to a file called ping_results
	if [ $? -eq 0 ]; then
		echo "insert your ip here .$ip is up"
		# Write the IP address of the active host to the ping_up.txt file
		echo "insert your ip here .$ip is up" >> ping_up.txt
		# Write the hostname of the active host to the ping_up.txt file
		host insert your ip here $ip >> ping_up.txt
	else
		echo "insert your ip here .$ip is down"
	fi
done
