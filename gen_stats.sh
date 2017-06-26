#!/bin/bash


clear
cd /home/ewa/bash_task3/

git checkout details
git pull origin details

xml=$(cat systemstats.xml)

CPULOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
echo $CPULOAD
MEMLOAD=$(free | grep Mem | awk '{print $3/$2 * 100.0"%"}')
echo $MEMLOAD
user=$(echo "$xml" | sed -n '/<user>/,/<\/user>/p')
process=$(echo "$xml" | sed -n '/<process>/,/<\/process>/p')

for who in $(who | cut -d' ' -f1 | sort | uniq);
do
	userBlock+=${user/<username>/<username>$who}
	while read -r var1 var2; do
		processBlock="${process/<pid>/<pid>$var1}"
		processBlock="${processBlock/<cmd>/<cmd>$var2}"
		processes+="$processBlock\n"
	done <<< "$(ps -u $who | awk '{print $1, $4}')"
	printf "$processes" > processes.xml
	userBlock=$(printf "$userBlock" | awk '/<\/username>/{p=1;print}/<\/user>/{p=0}!p')
	userBlock=$(printf "$userBlock" | sed -e '/<\/username>/r processes.xml')
done
	printf "$userBlock" > users.xml

xml=$(printf "$xml" | awk '/<\/memload>/{p=1;print}/<\/systemstats>/{p=0}!p')
xml=$(printf "$xml" | sed -e '/<\/memload>/r users.xml')
#printf "$xml"
DATE=$(date +%Y-%m-%d)
WEEKDAY=$(date +%u)
TIME=$(date +"%T")
xml=${xml/<date>/<date>$DATE}
xml=${xml/<weekday>/<weekday>$WEEKDAY}
xml=${xml/<time>/<time>$TIME}
xml=${xml/<cpuload>/<cpuload>$CPULOAD}
xml=${xml/<memload>/<memload>$MEMLOAD}
echo $xml > systemstats3.xml

git add systemstats3.xml
git commit -m "report2"
git push origin details

git checkout master
