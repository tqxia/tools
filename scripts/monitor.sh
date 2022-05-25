#!/bin/bash

pid=$1
duration=$2
echo "start sampling, pid: $pid, duration: $duration"

top -b -d 1 -p $pid > tmp.log &
tpid=$!
echo "sampling process(top) pid: $tpid"

sleep $duration
kill -9 $tpid
# process data
grep $pid tmp.log > filtered.tmp.log
cat filtered.tmp.log | awk '{sum+=$1} END {print "Average cpu usage = ", sum/NR}'
cat filtered.tmp.log | awk 'BEGIN {max = 0} {if ($9+0 > max+0) max=$9 fi} END {print "Max cpu usage =", max}'
cat filtered.tmp.log | awk 'BEGIN {min = 65536} {if ($9+0 < min+0) min=$9 fi} END {print "Min cpu usage =", min}'
# cleanup
rm -f *tmp.log