#!/bin/bash
set -euo pipefail

LOG="$HOME/var/log/weekly_raport_$(date +%d.%m.%Y).txt"
counter=0
iterations=60
total_counter=0
treshhold=80
df=$(df | awk 'NR>1 {print $5}' | tr -d '%')
mkdir -p "$(dirname "$LOG")"
log(){
    echo "[$(date +%H:%M:%S)] $1" | tee -a "$LOG"
}

while [ $counter -lt $iterations ]; do 
    cpu=$( top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | tr -d ',')
    mem=$( free -m | grep Mem | awk '{print $3"/"$2" MB"}')
    counter=$(( counter + 1 ))
    total_counter=$( echo "scale=1; $total_counter + $cpu " | bc)
    for i in $df ; do 
        if [ $i -gt $treshhold ]; then 
            log "[WARNING] DISK USAGE $i"
        else
            echo "evrything is okay"
        fi
    done
    sleep 1
done


avg=$( echo "scale=1; $total_counter / $iterations " | bc)
result="[CPU:$cpu] | [Mem:$mem] [AVG:$avg]"
log "$result"
