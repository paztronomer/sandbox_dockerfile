#!/bin/bash
VAR1='localhost'
VAR2=27017
VAR3='AllCellIds'
VAR4='SV-Y6_1M_p06_chunk02.csv'
# 'SV-Y6_1M_p05_chunk01.csv'
# 'SV-Y6_1M_p04_chunk4.csv'
# 'SV-Y6_1M_p04.csv'
# 'sample100000_se.csv'
# 'SV-Y6_100000.csv'
# 'SV-Y6_1000.csv'
# 'SV-Y6_Finalcut_Blacklist_noDuplicates.csv'

echo Runnign with $VAR4
docker run -d --name mongo_ingest -p 8080:27017 --env M_HOST=$VAR1 --env M_PORT=$VAR2 --env M_DBNAME=$VAR3 --env CSV_INPUT_DATA=$VAR4 -v /des004/deslabs/semongo/s2_mongoIngestion:/home/des/s2des/external -v /des004/deslabs/semongo/s2_mongoIngestion/sandbox_data/db_ingested_full/db:/data/db --rm fco/s2cut_ingest:v02

# -d

# docker run -d --name mongo_ingest -p 8080:27017 --env M_HOST='' --env M_PORT='' --env M_DBNAME='' --env CSV_INPUT_DATA='' -v /des004/deslabs/semongo/s2_mongoIngestion:/home/des/s2des/external --rm s2cut_ingest
