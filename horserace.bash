#!/bin/bash

i=0
for f in output{0..7}.log
do
	echo -n Caballo $i ... > $f
	let i=i+1
done
INI=$SECONDS
while true 
do
	i=$((RANDOM%8))
	fichero="output$i.log"
	sleep 0.5;
	sed -i -s 's,🐎, ,' $fichero
	echo -n 🐎 >> $fichero
	if test $((SECONDS-INI)) -gt 120
	then
		exit 1
	fi	
done  &

tput civis
while [ -n "$(jobs 2>&1)" ]
do
	tput sc
	for f in output*log;
	do
		sed -z 's,\([^\n]\)$,\1\n,' $f
	done
	tput rc
done
tput cvvis
