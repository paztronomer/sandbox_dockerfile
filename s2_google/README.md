# s2_mongoIngestion
S2 mongoDB ingestion

## For compilation
`docker build --target small -t s2cut_ingest . -f s2cut_toIngest.Dockerfie`

## For running
**put here the final calling, including the environmental variables**

## Steps
 1. Login steps: deslogin > descut/desgpu2.cosmology.illinois.edu
 2. Go to: `/des004/deslabs/semongo`
 3. Run the container, dettached (`-d`) with environment variables (`--env`)
     1. `docker run -d --name mongo_ingest -p 8080:27017 -v {full path}/s2_mongoIngestion:/home/des/s2des/external --env testvar='var01a' --rm s2cut_ingest`
 4. First do the ingestion of a sample list, because the large one seemed to overload the machine.
 5. Access the running container
     1. `docker ps`
     2. `docker exec -it mongo_ingest bash`
     3. to exit the container without stopping it, do `CTRL-P` then `CTRL-Q`
 6. Start cron scheduler and add a line to the crontab file
     1. `service cron start`
     2. `crontab -e`
     3. add `* * * * * bash /home/des/s2des/external/backup_db.sh >> /home/des/s2des/external/out_backupDB_cron.log 2>&1`
     4. check if the backup is happening 

## Pending
- [ ] implement the environmental variables
- [ ] check the ingestion of 10E5 entries
- [ ] run the big, all footprint ingestion
- [ ] check why the run ingestion log is not working
