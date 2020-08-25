#!/bin/bash
CONTAINER="pipeline"
VAR3="/home/pelican/Coding/qmostdr"
VAR4="/home/pelican/Coding/qmost_data/l1_devel"
# ==========================================
# Change it to docker compose for simplicity
# ==========================================

echo Attach to running container=${CONTAINER}, creating a new session
echo If you want to run in the same session, use attach
# Using --ENV for environment variables
# --security-opt="no-new-privileges:true" disable container processes of gaining new privileges
# --security-opt="apparmor=PROFILE" set the apparmor to be applied to the container. See https://docs.docker.com/engine/security/apparmor/
# --user="qmost":1001 to avoid issues with privileges in mounted volumes
# also --user $(id -u):$(id -g) but it sets to bash:1000 (user:group)
docker exec -it --user "fpc" ${CONTAINER} bash

#  --env L1_LABEL=$VAR2 \
#  -v $VAR3:/code -v $VAR4:/data \
#