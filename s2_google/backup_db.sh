echo ''
echo $(date)
rsync -varz --ignore-times /data/db/ /home/des/s2des/external/data_backup_recurrent/
echo '----'
