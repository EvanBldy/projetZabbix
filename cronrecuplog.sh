#!/bin/bash
 
loc="/home/etud/log_temp" #emplacement des logs
 
ssh $1@janus.info.univ-angers.fr "tail -1 $loc/ups_SU19202U-07@gs08-1.log ; tail -1 $loc/ups_SU27003U-08@neo.log ; tail -1 $loc/ups_SU19202U-10@h102-2.log ; tail -1 $loc/ups_SU27003U-09@h102-1.log" > valonduleurs.tmp
#met la dernière ligne de log de chaque onduleur dans un fichier (valonduleurs.tmp)
 
 
#ligne 1 : gs08-1
#ligne 2 : neo
#ligne 3 : h102-2
#ligne 4 : h102-1
