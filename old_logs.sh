#!/bin/bash

scp $2@janus.info.univ-angers.fr:/home/etud/log_temp/*$1* .
gunzip *$1*.gz -c > tmp.log ; cat *$1.log.1 *$1.log >> tmp.log

originalIFS=$IFS
IFS=$'\r\n'
tab=($(cat tmp.log | sort -nr  ))
rm *$1*
IFS=$originalIFS

nb_lines=$(expr ${#tab[@]})
            
for(( i=0;i<nb_lines;++i )) ; do
    YMD=($(echo ${tab[i]}  | cut  -d ' ' -f 1))
    TIME=($(echo ${tab[i]} | cut  -d ' ' -f 2))
    battery_charge=($(echo ${tab[i]}  | cut  -d ' ' -f 3))
    ups_load=($(echo ${tab[i]}  | cut  -d ' ' -f 4))
    battery_runtime=($(echo ${tab[i]}  | cut  -d ' ' -f 5))
    input_voltage=($(echo ${tab[i]}  | cut  -d ' ' -f 6))
    #battery_voltage=($(echo ${tab[i]}  | cut  -d ' ' -f 7))
    #status=($(echo ${tab[i]}  | cut  -d ' ' -f 8))
    #temperature=($(echo ${tab[i]}  | cut  -d ' ' -f 9))
    input_frequency=($(echo ${tab[i]}  | cut  -d ' ' -f 10))
    power=($(echo ${tab[i]}  | cut  -d ' ' -f 11 | tr -d "[:alpha:]"))

    if [ $input_frequency = "NA" ]
    then
        input_frequency=0
    fi
            
    var=$TIME
    size=2
    sep=:
    new=${var:0:$size}
    for (( j=size; j < ${#var}; j+=size )) ; do
        new+=$sep${var:$j:$size}
    done
    let "date_sec=($(date -d "$YMD $new" +'%s'))-3600"
            
    mysql -u zabbix --password=$3 -e "INSERT INTO zabbix.history_uint(itemid,clock,value,ns) VALUES ((select itemid from zabbix.items where name like 'power_$1'),$date_sec,$power,0),((select itemid from zabbix.items where name like 'input_voltage_$1'),$date_sec,$input_voltage,0),((select itemid from zabbix.items where name like 'ups_load_$1'),$date_sec,$ups_load,0),((select itemid from zabbix.items where name like 'battery_runtime_$1'),$date_sec,$battery_runtime,0);INSERT INTO zabbix.history(itemid,clock,value,ns) VALUES((select itemid from zabbix.items where name like 'battery_charge_$1'),$date_sec,$battery_charge,0),((select itemid from zabbix.items where name like 'input_frequency_$1'),$date_sec,$input_frequency,0);"
    echo "Ligne $i/$nb_lines PATIENCE !!!!!"
done

rm tmp.log