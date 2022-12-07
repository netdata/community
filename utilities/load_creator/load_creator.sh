#!/bin/bash

#Commands that we'll be using to create load
load_cpu="sha512sum /dev/urandom"
create_file="dd if=/dev/zero of=loadfile bs=1M count=1024 && for i in {1..30}; do cp loadfile loadfile1; done"
load_disk="for i in {1..30}; do cp loadfile loadfile1; done"
load_mem="tail /dev/zero 2> /dev/null"

# Load CPU for 30 seconds
echo "Generating CPU load for the next 30 seconds..."
$load_cpu &
load_cpu_pid=$!
sleep 30
kill $load_cpu_pid
echo "CPU load test complete, sleeping for 10 seconds..."
sleep 10

# Create a 1G file and copy it continuously 30 times
echo "Generating disk IO load..."
[ -e "loadfile" ] && eval $load_disk || eval $create_file
echo "Disk load test complete, sleeping for 10 seconds..."
sleep 10

# Create a sudden OOM event
echo "Generating memory load..."
$load_mem
echo "Memory load test complete, sleeping for 10 seconds..."
sleep 10
