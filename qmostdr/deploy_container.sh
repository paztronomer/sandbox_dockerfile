#!/bin/bash
VAR1="localhost"
VAR2="DEVEL"
VAR3="/home/pelican/Coding/qmostdr"
VAR4="/home/pelican/Coding/qmost_data/l1_devel"
USR_VOL_CODE="/home/fpc/code"
USR_VOL_DATA="/home/fpc/data"
VOL_CODE="/code"
VOL_DATA="/data"

# ==========================================
# Change it to docker compose for simplicity
# ==========================================

echo Running container with variables
# Using --ENV for environment variables
# --security-opt="no-new-privileges:true" disable container processes of gaining new privileges
# --security-opt="apparmor=PROFILE" set the apparmor to be applied to the container. See https://docs.docker.com/engine/security/apparmor/
# --user="qmost":1001 to avoid issues with privileges in mounted volumes
# also --user $(id -u):$(id -g) but it sets to bash:1000 (user:group)
# What I'm using is giving it as arg in the build. It can be overwritten here if
# needed
# if you wan t to avoid a user inside the contaioner to gain root privileges/execute sudo, even
# when the users is a sudoer, use:   --security-opt="no-new-privileges:true" \
docker run -i -t \
  --name pipeline -p 8000:8080 \
  --env L1_LABEL=$VAR2 \
  -v ${VAR3}:${USR_VOL_CODE} -v ${VAR4}:${USR_VOL_DATA} \
  --user $(id -u) \
  --rm \
  qmost/l1:v02.1
# -d / -it --rm
