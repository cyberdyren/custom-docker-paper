#!/bin/sh
set -e

DOCKER_USER='v18s1user'
DOCKER_GROUP='v18s1group'

if ! id "$DOCKER_USER" >/dev/null 2>&1; then
    echo "First start of the docker container, start initialization process..."

    USER_ID=${PUID:-9001}
    GROUP_ID=${PGID:-9001}
    echo "Starting with $USER_ID:$GROUP_ID (UID:GID)"

    addgroup --system --gid $GROUP_ID $DOCKER_GROUP
    #useradd -s "/bin/sh" -u $USER_ID --gid $DOCKER_GROUP -D $DOCKER_USER
    #useradd -s "/bin/sh" -u $USER_ID --gid $DOCKER_GROUP -D $DOCKER_USER
    useradd --shell "/bin/bash" --uid $USER_ID --gid $GROUP_ID $DOCKER_USER

    chown -vR $USER_ID:$GROUP_ID /mc/
    chmod -vR ug+rwx /mc/
    chown -vR $USER_ID:$GROUP_ID /mc
    echo "First start of the docker container, start initialization process..."
fi

export HOME=/home/$DOCKER_USER

echo "Skipping wait time for database warmup..."

echo "Setting up ssh password..."

echo "v18s1user:$SSH_ROOT_PASSWORD" | chpasswd 

echo "Checking git credentials.."

chown -R $DOCKER_USER /usr/share/git-core/templates/hooks

git config --global user.name "V18S1-Server"

git config --global user.email "V18S1@oppisoft.de"

echo "running git init..."
git init

echo "adding . to git"
git add .

echo "commiting..."

git commit -m "Server-Commit" -m "`$commitDate`"

echo "Starting ssh Server..."
/usr/sbin/sshd
echo "Ready..."

echo "Creating or attaching to tmux session..."

#iftop may not work due to missing privileges
exec gosu $DOCKER_USER tmux \
  new-session -s v18s1-server "exec iftop -i eth0 -f 'dst port 25565' ; read" \; \
  split-window "exec /usr/local/openjdk-17/bin/java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE $JAVAFLAGS /mc/paperspigot.jar nogui ; read" \; \
  select-layout even-horizontal
  

