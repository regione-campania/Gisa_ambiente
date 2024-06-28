#!/bin/bash

clear

#set -e

set -x

./stop.sh   
./build.sh  
if [ $? -eq 0 ] 
then 
 ./run.sh 
 ./status.sh
else 
  echo "go build error" 
fi
