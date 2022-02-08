# Custom Paper 1.18.1 Server

## Warning

A ssh server with password login is enabeld!!
> (Set the password as enviroment variable)

## Build and run the container

- clone the repo with
  
  ```sh
  git clone https://github.com/max-42/custom-docker-paper.git
  ```

- cd into the directory
- copy and edit [`example.env`](https://github.com/max-42/custom-docker-paper/blob/main/.env.example) to `.env` file and change the root password!

  ```sh
  docker volume create --name=v18s1_server_data
  
  docker-compose --env-file .env up --build
  ```

- if you need want to use other ports for the ssh server and the Paper Minecraft server, you can change them to in the `.env` file.


## Setup

here is a example how to install the `custom-docker-paper` server:
(Make sure you have at least git, nano and of course docker and docker-compose installed)
### Download the repository

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


### Create a the docker volume for the server

```sh
sudo docker volume create --name=v18s1_server_data
```

### Final Step: Setup throuh docker compose

```sh
sudo docker-compose --env-file .env up --build
```