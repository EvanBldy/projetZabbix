#!/bin/bash

scp $2@janus.info.univ-angers.fr:/home/etud/log_temp/*$1* . #récupération des logs de l'onduleur sur janus
gunzip *$1*.gz -c > tmp.log ; cat *$1.log.1 *$1.log >> tmp.log #met tous les logs en un seul fichier

originalIFS=$IFS #sauvegarde des séparateurs originaux
IFS=$'\r\n' #changement des séparateurs
tab=($(cat tmp.log | sort -nr  )) #stockage de toutes les lignes en un seul tableau
rm *$1* #suppression des fichiers de logs precedemment téléchargés
IFS=$originalIFS #les séparateurs orignaux sont remis

nb_lines=$(expr ${#tab[@]}) #calcul de nombre de lignes
            
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

#pour chaque tour de boucle stockage dans une variable chaque info respective
    if [ $input_frequency = "NA" ] #quand =NA input frequency =0
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

#transformation de la date en timestamp
            
    mysql -u zabbix --password=$3 -e "INSERT INTO zabbix.history(itemid,clock,value,ns) VALUES ((select itemid from zabbix.items where name like 'input_voltage_$1'),$date_sec,$input_voltage,0),((select itemid from zabbix.items where name like 'ups_load_$1'),$date_sec,$ups_load,0),((select itemid from zabbix.items where name like 'battery_runtime_$1'),$date_sec,$battery_runtime,0),((select itemid from zabbix.items where name like 'battery_charge_$1'),$date_sec,$battery_charge,0),((select itemid from zabbix.items where name like 'input_frequency_$1'),$date_sec,$input_frequency,0),((select itemid from zabbix.items where name like 'power_$1'),$date_sec,$power,0);"

#requete sql pour ajout de chaque info dans la BDD au niveau de la table zabbix.history 1 variable = 1 ligne dans la table 
#zabbix.history --> données en float
#zabbix.uint --> données en int

    echo "Ligne $i/$nb_lines PATIENCE !!!!!"
done

rm tmp.log