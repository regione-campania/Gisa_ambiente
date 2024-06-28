#!/bin/bash

FILE=$(basename $PWD)



if [ -f "./bin/$FILE" ]; then
   echo mv -f --backup=numbered "./bin/$FILE" "./old/$FILE"
   #mv -f --backup=numbered "./bin/$FILE" "./old/$FILE"
   rm -f  "./bin/$FILE" 
fi
echo $(date)
cd app
go build  -o "../bin/$FILE" *
echo $(date)

cd ..
##./stop.sh

