#!/bin/bash

# This script will scan the IP address range specified and display the IP address and hostname
# of any active hosts.

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
    echo 'Please run with sudo or as root.'
    exit 1
fi

# Create a Y/N prompt and ask the user if they want to manually enter an IP address range.

function promptyn {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

if promptyn "Do you want to manually enter an IP address range?"; then
    echo "Enter an IP address to scan: "
    read ipaddress
    for ip in $(seq 1 254); do
        ping -c $ipaddress.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
        # Write the output of the ping command to a file called ping_results
        if [ $? -eq 0 ]; then
            echo "$ipaddress.$ip is up"
            # Write the IP address of the active host to the ping_up.txt file
            echo "$ipadress.$ip is up" >> ping_up.txt
            # Write the hostname of the active host to the ping_up.txt file
            host $ipaddress.$ip >> ping_up.txt
        else
            echo "$ipaddress.$ip is down"
        fi
    done
else
    # Scan for an ip using ifconfig and store the output in a variable called "ifconfig_ip"
    ifconfig_ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '
    ')
    # Scan for an ip using nmap and store the output in a variable called "nmap_ip"
    nmap_ip=$(nmap -sP $ip | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '
    ')
    # Scan for an ip using arp and store the output in a variable called "arp_ip"
    arp_ip=$(arp -a | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '
    ')
fi