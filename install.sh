#!/bin/sh
echo"You may not execute this, but u can copy paste <3 thx ;)"
echo"docker volume create --name=tobi_server_data"
echo"docker-compose --env-file .env up"
exit #prevents execution

docker volume create --name=tobi_server_data
docker-compose --env-file .env up