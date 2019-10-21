#!/bin/bash

function print_horses()
{
	for f in output*log;
	do
		sed -z 's,\([^\n]\)$,\1\n,' $f
	done
}

function finish()
{
	print_horses
	winer=$(wc -c output*log | sort -n | grep -v total | 
		sed -n -e '$s,.*t,,' -e '$s,\..*,,p')
	echo "Horse $winer win!"
	\rm -f output*log
	tput cvvis
	exit 0
}

trap finish exit


i=0
for f in output{0..7}.log
do
	echo -n Horse $i ... > $f
	let i=i+1
done
INI=$SECONDS
tput civis
while true 
do
	i=$((RANDOM%8))
	fichero="output$i.log"
	sleep 0.1;
	sed -i -s 's,🐎, ,' $fichero
	echo -n 🐎 >> $fichero
	if test $((SECONDS-INI)) -gt 20
	then
		exit 0
	else
		tput sc
		print_horses
		tput rc
	fi	
done  
exit 0
