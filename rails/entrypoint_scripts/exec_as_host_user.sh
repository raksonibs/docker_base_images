# we find the host uid/gid by assuming the app's `docker-compose.yml` belongs to the host
HOST_UID=$(stat -c %u docker-compose.yml)
HOST_GID=$(stat -c %g docker-compose.yml)

USERNAME=docker

# On first run, create a user and group with same uid/gid as the host
# This is a no-op on subsequent runs (since user already exists)
groupadd -f -g $HOST_GID $USERNAME
useradd -o --shell /bin/bash -u $HOST_UID -g $HOST_GID -m $USERNAME

# Make sure this user is a sudoer
LINE="$USERNAME ALL=(ALL) NOPASSWD:SETENV:ALL"
grep -qF "${LINE}" "/etc/sudoers" || echo "${LINE}" >> "/etc/sudoers"
LINE="Defaults always_set_home"
grep -qF "${LINE}" "/etc/sudoers" || echo "${LINE}" >> "/etc/sudoers"

exec sudo -E -u $USERNAME PATH=/app/bin:$PATH docker-ssh-exec $@
