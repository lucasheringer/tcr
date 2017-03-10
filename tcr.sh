	#!/bin/bash

##starting counters
counter=20
i=1
slowestHop=""
temp=0.0

##Checking if host is valid or is alive
ping -q -c 1 $1 >> /dev/null
RETURN=$?
if [ "$RETURN" -gt 1 ]
then
	echo "Host unreachable or doesn't exist!"
	exit 1
fi

##starting traceroute
while [ $i -lt $counter ]
do
	### reading the hop ip and hostname
	hop=`ping -c 1 -t $i $1|grep icmp_seq|grep -oP '\(\K[^)]+'`
  host=`ping -c 1 -t $i $1|grep icmp_seq|cut -d " " -f 2`

	if [ "$?" -eq 0 ]
	then
		result=`ping -c 1 $hop | grep from` >> /dev/null
		#echo $result
		## reading ping time to hop
		time1=`echo $result | cut -d "=" -f 4|cut -d " " -f 1`
		#echo $time1 $temp
		## checking if it's not empty
		if [ "$host" != "bytes" ] && [ ! -z "$host" ]
		then
			### printing info
			echo $i $host $time1 "ms"
		fi
		if [ ! -z "$time1" ]
		then
			###Checking and saving the slowest hop
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
		### geting and printing the last hop
		result=`ping -c 1 -t $i $1|grep icmp_seq`
		echo $result
	fi
	### increasing the TTL ping value until reaches the counter.
	i=$[$i+1]
done

###printing the slowest hop
echo "#################################"
echo "Slowest hop: "$slowestHop
