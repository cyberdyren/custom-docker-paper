# Custom Folia 1.20.2 Server

[![Install-Video](https://upload.oppisoft.de/x/4d8nL4u2b4u8Ndf.gif)](https://upload.oppisoft.de/x/4d8nL4u2b4u8Ndf.mp4)
> Klick the video for higher quality.

## Warning

A ssh server with password login is enabeld!!
> (Set the password as enviroment variable in the .env file ([see below](#edit-the-env-file))


## Setup

here is a example how to install the `v18s1` server:
(Make sure you have at least git, nano and of course docker and docker-compose installed)
### Clone the repository

```sh
git clone https://github.com/max-42/v18s1.git
```

### Change the working directory into the source

```sh
cd custom-docker-paper
```

### Copy the sample [`example.env`](https://github.com/max-42/v18s1/blob/main/.env.example) file

```sh
cp ./.env.example ./.env
```

### Edit the .env file

```sh
nano ./.env
```

Here you can **change the SSH password** and the ports that the server should (SSH and Folia, Web) use.


### Create a the docker volumes for the server

```sh
sudo docker volume create --name=v18s1_server_data
sudo docker volume create --name=v18s1_db
sudo docker volume create --name=traefik_certificates
```

### Final Step: Setup throuh docker compose

```sh
sudo docker-compose --env-file .env up --build
```

## If you are already using [Treafik Proxy](https://doc.traefik.io/traefik/)

please 
```

if you want to enable the treafik dashboard change do the following
-  change - ```"--api.dashboard=false"``` to ```true```.
-  uncomment the entire ```labels:``` section
-  run ```htpasswd -nb username y0uRSecuRePassw0rD  | sed -e s/\\$/\\$\\$/g``` to generate the basicauth string (change **username** and **y0uRSecuRePassw0rD**)
-  insert the string generated in the step above into ```traefik.http.middlewares.traefik-auth.basicauth.users="<string>"```
-  change **```treafik.example.com```** into your domain. (Remember to add a CNAME, AAAA or A record before, so that it resolves to your VPS)
