#!/bin/bash

pid=$1

top -b -d 1 -p $pid > tmp.log

rm -f tmp.log