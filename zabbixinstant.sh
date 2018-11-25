#!/bin/bash
 
#choix de l'onduleur $2 (ajout de p pour le choix de ligne)
case $2 in
	"gs08-1")
		onduleur=1p;;
	"neo")
		onduleur=2p;;
	"h102-2")
		onduleur=3p;;
	"h102-1")
		onduleur=4p;;
esac
 
valonduleurs=~/valonduleurs.tmp
 
#choix de l'element $1
case $1 in
	"battery_charge")
		sed -n $onduleur $valonduleurs | cut -d ' ' -f 3  ;;
	"ups_load")
		sed -n $onduleur $valonduleurs | cut -d ' ' -f 4  ;;
	"battery_runtime")
		sed -n $onduleur $valonduleurs | cut -d ' ' -f 5  ;;
	"input_voltage")
		sed -n $onduleur $valonduleurs | cut -d ' ' -f 6  ;;
	"battery_voltage")
		sed -n $onduleur $valonduleurs | cut -d ' ' -f 7  ;;
	"status")
		sed -n $onduleur $valonduleurs | cut -d ' ' -f 8  ;;
	"temperature")
		sed -n $onduleur $valonduleurs | cut -d ' ' -f 9  ;;
	"input_frequency")
		input_frequency=`sed -n $onduleur $valonduleurs | cut -d ' ' -f 10`
		if [ $input_frequency = "NA" ]
		then
			input_frequency=0
		fi
		echo $input_frequency ;;
	"power")
		sed -n $onduleur $valonduleurs | cut -d ' ' -f 11 | tr -d "[:alpha:]" ;;
	"time")
        sed -n $onduleur $valonduleurs | cut -d ' ' -f 1,2  ;;
esac
