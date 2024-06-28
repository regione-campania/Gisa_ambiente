#!/bin/bash

PORT=8083
echo "status from pid:"
ps --pid $(cat pid/running.pid) 2> /dev/null
echo "--"
echo "status from port"
netstat -ntlp | grep $PORT| awk -F ' ' '{print "port", $4, " - ", "pid/process ", $7}'
echo ""
