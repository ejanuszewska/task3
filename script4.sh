#!/bin/bash

clear
cd /home/ewa/bash_task3/

git checkout details
git pull origin details

git checkout summary
git pull origin summary

git checkout details
hash=$(git rev-parse HEAD)
git checkout summary
git cherry-pick $hash --strategy=recursive -X theirs
git checkout details

CPULOADS=()
MEMLOAD=()
fileCat=$(git show HEAD:systemstats3.xml)
#echo $fileCat
CPULOADS+=$(echo "$fileCat" | sed -n '/<cpuload>/,/<\/cpuload>/p')
MEMLOADS+=$(echo "$fileCat" | sed -n '/<memload>/,/<\/memload>/p')

for(( i=1; i<5; i++))
do
fileCat=$(git show HEAD~$i:systemstats3.xml)
CPULOADS+=$(echo "$fileCat" | sed -n '/<cpuload>/,/<\/cpuload>/p')
MEMLOADS+=$(echo "$fileCat" | sed -n '/<memload>/,/<\/memload>/p')
done

CPULOADSAVERAGE=CPULOADS/5
MEMLOADSAVERAGE=MEMLOADS/5

xml=$(cat average.xml)

DATE=$(date +%Y-%m-%d)
WEEKDAY=$(date +%u)
TIME=$(date +"%T")
xml=${xml/<date>/<date>$DATE}
xml=${xml/<weekday>/<weekday>$WEEKDAY}
xml=${xml/<time>/<time>$TIME}
xml=${xml/<cpuload>/<cpuload>$CPULOADSAVERAGE}
xml=${xml/<memload>/<memload>$MEMLOADSAVERAGE}

git checkout summary
echo $xml > average3.xml

git add average3.xml
git commit --amend -m "summary report"
git push origin summary
git checkout master
