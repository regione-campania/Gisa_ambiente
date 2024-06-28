#!/bin/bash

FILE=$(basename $PWD)

#echo "$FILE start: $(date)">>exec.log 
NO_PROXY=*
cmd=bin/${FILE}  
$cmd  disown >log/out.txt 2>log/err.txt &
echo $! >pid/running.pid
#tail -f nohup.out
