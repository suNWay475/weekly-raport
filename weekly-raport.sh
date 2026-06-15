#!/bin/bash
# weekly_report.sh — collects system metrics for 60 seconds and saves a report to a log file

set -euo pipefail

# Path to the log file with today's date in the filename
LOG="$HOME/var/log/weekly_raport_$(date +%d.%m.%Y).txt"

# Loop counters
counter=0
iterations=60

# Accumulator for CPU values (used to calculate average)
total_counter=0

# Disk usage warning threshold in percent
treshhold=80

# Collect disk usage percentages for all partitions (once at startup)
df=$(df | awk 'NR>1 {print $5}' | tr -d '%')

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG")"

# Logging function — prepends timestamp and writes to log file
log(){
    echo "[$(date +%H:%M:%S)] $1" | tee -a "$LOG"
}

# Main loop — runs for 60 seconds (1 iteration per second)
while [ $counter -lt $iterations ]; do

    # Get current CPU usage percent (idle subtracted by top)
    cpu=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | tr -d ',')

    # Get RAM usage in MB (used/total)
    mem=$(free -m | grep Mem | awk '{print $3"/"$2" MB"}')

    counter=$(( counter + 1 ))

    # Add current CPU value to accumulator for average calculation
    total_counter=$(echo "scale=1; $total_counter + $cpu" | bc)

    # Check each partition's disk usage against the threshold
    for i in $df; do
        if [ $i -gt $treshhold ]; then
            log "[WARNING] DISK USAGE $i%"
        else
            echo "everything is okay"
        fi
    done

    sleep 1
done

# Calculate average CPU usage over the monitoring period
avg=$(echo "scale=1; $total_counter / $iterations" | bc)

# Build final summary line and write to log
result="[CPU:$cpu] | [Mem:$mem] [AVG:$avg]"
log "$result"