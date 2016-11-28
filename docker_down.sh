#!/bin/sh
name=dbparser-postgres
id=$(docker ps -aq -f name=$name)

if [ -z "$id" ]; then
    echo "Container not available"
else
    echo "Container found...stopping"
    docker stop $id
fi



