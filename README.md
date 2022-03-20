# Custom Paper 1.18.1 Server

[![Install-Video](https://upload.oppisoft.de/x/4d8nL4u2b4u8Ndf.gif)](https://upload.oppisoft.de/x/4d8nL4u2b4u8Ndf.mp4)

## Warning

A ssh server with password login is enabeld!!
> (Set the password as enviroment variable in the .env file ([see below](#edit-the-env-file))


## Setup

here is a example how to install the `custom-docker-paper` server:
(Make sure you have at least git, nano and of course docker and docker-compose installed)
### Clone the repository

```sh
git clone https://github.com/max-42/custom-docker-paper.git
```

### Change the working directory into the source

```sh
cd custom-docker-paper
```

### Copy the sample [`example.env`](https://github.com/max-42/custom-docker-paper/blob/main/.env.example) file

```sh
cp ./.env.example ./.env
```

### Edit the .env file

```sh
nano ./.env
```
Here you can **change the SSH password** and the ports that the server should (SSH and Paper) use.



### Create a the docker volume for the server

```sh
sudo docker volume create --name=v18s1_server_data
```

### Final Step: Setup throuh docker compose

```sh
sudo docker-compose --env-file .env up --build
```
