#!/bin/bash

FILE=$(basename $PWD)

#echo "$FILE start: $(date)">>exec.log 
kill $(cat pid/running.pid) 2>/dev/null
kill $(pidof $FILE) 2>/dev/null
#echo "$FILE end  : $(date)" >>exec.log
