#!/bin/bash

LIST=`ls $(pwd)`

#echo $LIST

for file in $LIST; do
    if [ ! -r $file ]; then
	echo $file
    fi
done
