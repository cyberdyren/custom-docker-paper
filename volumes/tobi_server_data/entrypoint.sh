#!/bin/sh
set -e

V18S1_USER='v18s1'
V18S1_GROUP='v18s1group'

if ! id "$v18s1_USER" >/dev/null 2>&1; then
    echo "First start of the v18s1 container, start initialization process..."

    USER_ID=${PUID:-9001}
    GROUP_ID=${PGID:-9001}
    echo "Starting with $USER_ID:$GROUP_ID (UID:GID)"

    addgroup --system --gid $GROUP_ID $v18s1_GROUP
    #useradd -s "/bin/sh" -u $USER_ID --gid $v18s1_GROUP -D $v18s1_USER
    #useradd -s "/bin/sh" -u $USER_ID --gid $V18S1_GROUP -D $V18S1_USER
    useradd --shell "/bin/bash" --uid $USER_ID --gid $GROUP_ID $V18S1_USER

    chown -vR $USER_ID:$GROUP_ID /mc/
    chmod -vR ug+rwx /mc/
    chown -vR $USER_ID:$GROUP_ID /mc
    echo "First start of the v18s1 container, start initialization process..."
fi

export HOME=/home/$V18S1_USER

echo "Skipping wait time for database warmup..."

echo "Starting ssh Server..."
/usr/sbin/sshd
echo "Ready..."

echo "Creating or attaching to tmux session..."

#iftop may not work due to missing privileges
exec gosu $V18S1_USER tmux \
  new-session -s mc-server "exec iftop -i eth0 -f 'dst port 25565' ; read" \; \
  split-window "exec /usr/local/openjdk-16/bin/java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE $JAVAFLAGS /mc/paperspigot.jar --nojline nogui ; read" \; \
  select-layout even-horizontal
  


