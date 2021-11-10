#!/bin/sh

for i in {20..01}
do
tput cup 10 $l
echo "Warning: Remember to copy the .env.example to .env File and CHANGE THE PASSWORD!"
echo -n "$i"
sleep 1
done

docker volume create --name=tobi_server_data

docker-compose --env-file .env up