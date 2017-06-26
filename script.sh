#!/bin/bash

clear

CPULOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
echo $CPULOAD
MEMLOAD=$(free | grep Mem | awk '{print $3/$2 * 100.0"%"}')
echo $MEMLOAD

for pid in `ps | awk '{print $2}'`; do
	echo "$pid"
done

read_dom () {
	local IFS=\>
	read -d \< ENTITY CONTENT
}

#while read_dom; do
	#echo "$ENTITY => $CONTENT"
#done < systemstats.xml

while read_dom; do
	case "$ENTITY" in
		'date')
		CONTENT=$(date +%Y-%m-%d)
		echo $CONTENT
		;;
		'weekday')
		CONTENT=$(date +%u)
		;;
		'time')
		CONTENT=$(date +"%T")
		;;
		'cpuload')
		CONTENT=$CPULOAD
		;;
		'memload')
		CONTENT=$MEMLOAD
		;;
	esac
done < systemstats.xml > systemstats2.xml
#> systemstats.xml.t ; mv systemstats.xml{.t,}

