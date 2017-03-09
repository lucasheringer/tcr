#!/bin/bash

##starting counters
counter=30
i=1
slowestHop=""
temp=0.0

##Checking if host is valid or is alive
ping -q -c 1 $1 >> /dev/null
if [ "$?" -ne 0 ]
then
	echo "Host unreachable or doesn't exist!"
	exit 1
fi

##starting traceroute
while [ $i -lt $counter ]
do
	hop=`ping -c 1 -t $i $1| grep -i from | cut -d " " -f 2`

	if [ "$hop" != "bytes" ]
	then
		result=`ping -c 1 $hop | grep from`
		echo $result
		time1=`echo $result | cut -d "=" -f 4|cut -d " " -f 1`
		echo "outside"
		#### IF not working
		if (( $(echo "$time1" > "$temp" |bc -l) ))
		then
			echo "inside"
			$temp=$time1
			echo $time1 $temp
			#$slowestHop=$hop $time1 ms
		fi
		i=$[$i+1]
	else
		result=`ping -c 1 $1 | grep from`
		echo $result
		time1=`echo $result | cut -d "=" -f 4|cut -d " " -f 1`
		i=31
	fi
done
