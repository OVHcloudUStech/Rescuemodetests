#tests hardware in rescue mode - note memory test can take a while 

#!/bin/bash

echo "Starting hardware diagnostics..."

# Processor Test
echo "Running processor test..."
WRKR=$(grep -c "^processor" /proc/cpuinfo)
stress-ng --metrics-brief --timeout 60s --cpu $WRKR --io $WRKR --aggressive --ignite-cpu --maximize --pathological
stress-ng --metrics-brief --timeout 60s --brk 0 --stack 0 --bigheap 0 

# Network Connection Test
echo "Running network connection test..."
ping -c 10 proof.ovh.net
for file in 1Mb 10Mb 100Mb 1Gb ; do 
    time curl -4f https://proof.ovh.net/files/${file}.dat -o /dev/null
done

# Memory Test
echo "Running memory test..."
RAM="$(awk -vOFMT=%.0f '$1 == "MemAvailable:" {print $2/1024 - 1024}' /proc/meminfo)"
memtester ${RAM}M 1

# Disk Partitions Test
echo "Running disk partitions test..."
stress-ng --metrics-brief --timeout 60s --hdd 0 --aggressive

echo "Diagnostics completed!"
