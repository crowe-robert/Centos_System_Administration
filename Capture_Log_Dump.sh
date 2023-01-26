#!/bin/bash

# Part 1 - Perform packet capture on all interfaces using tcpdump

# Create MASTER directory
mkdir MASTER

# Create PCAP subdirectory
mkdir MASTER/PCAP

# Get list of interfaces using tcpdump -D command
interfaces=$(tcpdump -D | awk '{print $2}' | sed 's/://')

# Perform packet capture on each interface
for interface in $interfaces; do
    tcpdump -w MASTER/PCAP/$interface.pcap -c 100 -tttt -i $interface &
done

# Part 2 - Gather log information from /var/log directory

# Create LOG subdirectory
mkdir MASTER/LOG

# Get list of log files in /var/log directory
log_files=$(find /var/log -type f -name "*.log" -not -name "*.gz")

# Use tail command to list last 200 lines of each log file
for log_file in $log_files; do
    tail -n 200 $log_file > MASTER/LOG/$(basename $log_file).txt &
done

# Part 3 - List all installed applications

# Use dnf list installed command to get list of installed applications
installed_apps=$(dnf list installed)

# Save list of installed applications to file
echo "$installed_apps" > MASTER/APPLICATION_LIST.txt

# Compress MASTER folder using tar command
tar -czvf MASTER.tar.gz MASTER
