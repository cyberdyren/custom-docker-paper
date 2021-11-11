# Custom Paper 1.17.1 Server for Tobi

## Warning

A ssh server with password login is enabeld!!

## Build and run the container

- clone the repo with
  
  ```sh
  git clone https://github.com/cyberdyren/custom-docker-paper.git
  ```

- cd into the directory
- copy and edit [`example.env`](https://github.com/cyberdyren/custom-docker-paper/blob/main/.env.example) to `.env` file and change the root password!

  ```sh
  docker volume create --name=tobi_server_data
  
  docker-compose --env-file .env up --build
  ```

- if you need want to use other ports for the ssh server and the Paper Minecraft server, you can change them to in the `.env` file.


### for the extreme lazy people

here is a example how to install the `custom-docker-paper` server:
(Make sure you have at least git, nano and of course docker and docker-compose installed)

```sh
git clone https://github.com/cyberdyren/custom-docker-paper.git
cd custom-docker-paper
cp ./.env.example ./.env
nano ./.env
sudo docker volume create --name=tobi_server_data
sudo docker-compose --env-file .env up --build
```
