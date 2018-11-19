#!/bin/bash

dirlog=/home/etud/log_temp/

case $1 in
	"battery_charge")
		tail -1 $dirlog*$2.log | cut -d ' ' -f 3  ;;
	"ups_load")
		tail -1 $dirlog*$2.log | cut -d ' ' -f 4  ;;
	"battery_runtime")
		tail -1 $dirlog*$2.log | cut -d ' ' -f 5  ;;
	"input_voltage")
		tail -1 $dirlog*$2.log | cut -d ' ' -f 6  ;;
	"battery_voltage")
		tail -1 $dirlog*$2.log | cut -d ' ' -f 7  ;;
	"status")
		tail -1 $dirlog*$2.log | cut -d ' ' -f 8  ;;
	"temperature")
		tail -1 $dirlog*$2.log | cut -d ' ' -f 9  ;;
	"input_frequency")
		input_frequency=`tail -1 $dirlog*$2.log | cut -d ' ' -f 10`
		if [ $input_frequency = "NA" ]
		then
			input_frequency=0
		fi
		echo $input_frequency ;;
	"power")
		tail -1 $dirlog*$2.log | cut -d ' ' -f 11 | tr -d "[:alpha:]" ;;
	"time")
        tail -1 $dirlog*$2.log | cut -d ' ' -f 1,2  ;;
esac