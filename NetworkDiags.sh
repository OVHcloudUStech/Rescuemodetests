#This script configures network settings, starts an iperf3 server, and performs various network diagnostics including traceroute, MTR, ping, and bandwidth tests using iperf3 and wget.

#!/bin/bash

# Ensure port 5201 is open
iptables -A INPUT -p tcp --dport 5201 -j ACCEPT

# Start iperf3 server in the background
iperf3 -s &

# Give the server a second to start
sleep 1

# Enter your Source and Destination IPs here
SOURCE_IP="51.81.10.125"
DESTINATION_IP="51.81.106.117"

# Traceroute from Source to Destination
echo "Traceroute from $SOURCE_IP to $DESTINATION_IP"
traceroute $DESTINATION_IP

# To run Traceroute from Destination to Source, you need to execute a similar command on the destination machine

# MTR from Source to Destination
echo "MTR from $SOURCE_IP to $DESTINATION_IP"
mtr --report --report-cycles 10 $DESTINATION_IP

# To run MTR from Destination to Source, you'd need to execute a similar command on the destination machine

# Ping from Source to Destination
echo "Ping from $SOURCE_IP to $DESTINATION_IP"
ping $DESTINATION_IP -c 100

# To run ping from Destination to Source, you'd need to execute a similar command on the destination machine

# Wget examples
wget https://vin.proof.ovh.us/files/1Gb.dat -O /dev/null
wget https://vin.proof.ovh.us/files/10Gb.dat -O /dev/null

# Iperf3 examples
iperf3 -c vin.proof.ovh.us -p 5201 -i 1 -u -t 30 -b 980M
iperf3 -c vin.proof.ovh.us -i 2 -t 20 -P 5

echo "All tasks completed!"

# Optionally, kill the iperf3 server after all tests are done
killall iperf3
