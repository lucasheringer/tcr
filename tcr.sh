#!/bin/bash

counter=5
i=1

while [ $i -lt $counter ]
do
	ping -c 1 -t $i $1 | grep From
	i=$[$i+1]
done
