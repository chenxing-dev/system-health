#!/bin/bash

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Collect system metrics
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
AVAILABLE_MEM=$(free -m | awk '/Mem:/ {print $4}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5 " used / " $4 " free"}')
TOP_PROCESSES=$(ps -eo user,%cpu,cmd --sort=-%cpu --no-headers | head -n 5 | awk '
BEGIN { printf "%-6s  %s\n", "CPU%", "COMMAND" } 
{
    # Extract command and truncate to 50 characters
    cmd = substr($0, index($0,$3))
    cmd_short = (length(cmd) > 50) ? substr(cmd,1,50) "..." : cmd
    printf "%-6s  %s\n", $2, cmd_short
}')

# Print metrics
echo "===== System Health Report: $TIMESTAMP ====="
echo "CPU Usage: $CPU_USAGE%"
echo "Available Memory: $AVAILABLE_MEM MB"
echo "Disk Usage (Root): $DISK_USAGE"
echo -e "\nTop 5 Processes by CPU:"
echo "$TOP_PROCESSES"