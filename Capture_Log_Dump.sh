#!/bin/bash
# Packet capture and log dump to facillitate diagnostics on Centos 9 
# Stream
#
# Copyright 2023 Robert Crowe
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the Apache License as published by
# the Apache Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# Apache License for more details.
#
# You should have received a copy of the Apache License
# along with this program.  If not, see <https://apache.org/licenses/>.

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
