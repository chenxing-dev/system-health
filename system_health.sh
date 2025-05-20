#!/bin/bash

# Configurable variable
TOP_PROCESSES_NUM=7 # Set number of processes to show

# Collect system metrics

# System Information Functions
get_kernel_version() {
    uname -r
}

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5 " used / " $4 " free"}')
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
AVAILABLE_MEM=$(free -m | awk '/Mem:/ {print $4}')

get_cpu_usage() {
    ps --no-headers -eo %cpu,comm,cmd --sort=-%cpu | head -n "$TOP_PROCESSES_NUM" | awk '
    BEGIN {printf "\033[1;38m%-6s %-10s %s \033[0m\n", "CPU%", "COMMAND", "CMD"} 
    {printf "%-6s %-10s %s\n", $1, $2, $3}'
}

# Print metrics
echo -e "\033[1;37m╔══════════════════════════════════════════════════╗
║  SYSTEM HEALTH REPORT • $(date +"%b %d, %Y • %I:%M %p")  ║
╚══════════════════════════════════════════════════╝\033[0m"

# System Overview
printf "\033[1;38m%-18s \033[0m%s\n" "Kernel Version:" "$(get_kernel_version)"
printf "\033[1;38m%-18s \033[0m%s\n" "Disk Usage (/):" "$DISK_USAGE"
printf "\033[1;38m%-18s \033[0m%s\n" "CPU Usage:" "${CPU_USAGE}%"
printf "\033[1;38m%-18s \033[0m%s\n" "Available Memory:" "${AVAILABLE_MEM} MB"

# Process Table
# echo -e "\nTop $TOP_PROCESSES_NUM Processes by CPU:"
echo 
get_cpu_usage
echo