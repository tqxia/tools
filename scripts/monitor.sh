#!/bin/bash

pid=$1
duration=$2
echo "Start sampling, target pid: $pid, duration: $duration seconds"

top -b -d 1 -p $pid > tmp.log &
tpid=$!
echo "Sampling process(top) pid: $tpid"

sleep $duration
kill $tpid

grep $pid tmp.log > filtered.tmp.log
# Process & display CPU statistics
printf "\nCPU usage statistics:\n"
cat filtered.tmp.log | awk '{sum+=$9} END {print "Average =", sum/NR}'
cat filtered.tmp.log | awk '{print $9}' | sort | awk ' {a[i++] = $1} END {print "Median =", a[int(i/2)]}'
cat filtered.tmp.log | awk 'BEGIN {max = 0} {if ($9+0 > max+0) max=$9 fi} END {print "Max =", max}'
cat filtered.tmp.log | awk 'BEGIN {min = 65536} {if ($9+0 < min+0) min=$9 fi} END {print "Min cpu =", min}'
# Process & display memory statistics
printf "\nMEM usage statistics:\n"
cat filtered.tmp.log | awk '{sum+=$6} END {print "Average =", sum/NR}'
cat filtered.tmp.log | awk '{print $6}' | sort | awk ' {a[i++] = $1} END {print "Median =", a[int(i/2)]}'
cat filtered.tmp.log | awk 'BEGIN {max = 0} {if ($6+0 > max+0) max=$6 fi} END {print "Max =", max}'
cat filtered.tmp.log | awk 'BEGIN {min = 65536} {if ($6+0 < min+0) min=$6 fi} END {print "Min cpu =", min}'
# cleanup
rm -f *tmp.log