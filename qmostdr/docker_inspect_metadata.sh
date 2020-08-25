#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo "Call the script using:"
    echo "> bash docker_inspect_metadata.sh IMAGE_NAME"
    exit 0
fi

DOCKER_NAME=$1

docker image inspect --format '{{ index .Config.Labels "com.docker.compose.project"}}' $DOCKER_NAME