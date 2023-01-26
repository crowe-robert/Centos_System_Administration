import os
import subprocess

# Part 1 - Perform packet capture on all interfaces using tcpdump

# Create MASTER directory
os.mkdir("MASTER")

# Create PCAP subdirectory
os.mkdir("MASTER/PCAP")

# Get list of interfaces using tcpdump -D command
interfaces = subprocess.run(["tcpdump", "-D"], capture_output=True).stdout.decode().split("\n")
interfaces = [i for i in interfaces if i != ""] # remove empty strings

# Perform packet capture on each interface
for interface in interfaces:
    subprocess.run(["tcpdump", "-w", f"MASTER/PCAP/{interface}.pcap", "-c", "100", "-tttt", "-i", interface])

# Part 2 - Gather log information from /var/log directory

# Create LOG subdirectory
os.mkdir("MASTER/LOG")

# Get list of log files in /var/log directory
log_files = [f for f in os.listdir("/var/log") if f.endswith(".log") and not f.endswith(".gz")]

# Use tail command to list last 200 lines of each log file
for log_file in log_files:
    output = subprocess.run(["tail", "-n", "200", f"/var/log/{log_file}"], capture_output=True).stdout.decode()
    with open(f"MASTER/LOG/{log_file}.txt", "w") as f:
        f.write(output)

# Part 3 - List all installed applications

# Use dnf list installed command to get list of installed applications
installed_apps = subprocess.run(["dnf", "list", "installed"], capture_output=True).stdout.decode()

# Save list of installed applications to file
with open("MASTER/APPLICATION_LIST.txt", "w") as f:
    f.write(installed_apps)

# Compress MASTER folder using tar command
subprocess.run(["tar", "-czvf", "MASTER.tar.gz", "MASTER"])
