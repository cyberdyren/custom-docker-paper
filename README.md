# Custom Paper 1.17.1 Server for Tobi

## Warning

A ssh server for the root user with password login is enabeld!!

## Build and run the container

- clone the repo with
  
  ```sh
  git clone https://github.com/cyberdyren/custom-docker-paper.git
  ```

- copy and edit [`example.env`](https://github.com/cyberdyren/custom-docker-paper/blob/main/.env.example) to `.env` file and change the root password!

  ```sh
  docker volume create --name=tobi_server_data
  
  docker-compose --env-file .env up
  ```

- if you need want to use other ports for the ssh server and the Paper Minecraft server, you can change them to in the `.env` file.
