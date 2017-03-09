#!/bin/bash

##starting counters
counter=15
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
	hop=`ping -c 1 -t $i $1|grep icmp_seq|grep -oP '\(\K[^)]+'`
  host=`ping -c 1 -t $i $1|grep icmp_seq|cut -d " " -f 2`
	if [ "$?" -eq 0 ]
	then
		result=`ping -c 1 $hop | grep from` >> /dev/null
		#echo $result
		time1=`echo $result | cut -d "=" -f 4|cut -d " " -f 1`
		#echo $time1 $temp
		if [ "$host" != "bytes" ] && [ ! -z "$host" ]
		then
			echo $i $host $time1 "ms"
		fi
		if [ ! -z "$time1" ]
		then
			if [ $(echo " $time1 > $temp" | bc) -eq 1 ]
			then
				temp=$time1
				slowestHop="$hop $time1 ms"
				#echo $time1 $temp $slowestHop
			fi
		else
			echo "  *  *  *  *"
		fi
	else
		result=`ping -c 1 -t $i $1|grep icmp_seq` >> /dev/null
		echo $result
	fi
	i=$[$i+1]
done

echo "Slowest hop: "$slowestHop
