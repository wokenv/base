#!/bin/sh

# Runs the command as the host user (USER_ID:GROUP_ID) instead of root, so
# that wp-env creates files with the right owner and builds its images for
# that user. Without USER_ID and GROUP_ID the command runs as is.
#
# /etc/passwd and /etc/group are edited directly: it works the same on every
# base image and does not depend on adduser/useradd flavours.

set -eu

if [ -z "${USER_ID:-}" ] || [ -z "${GROUP_ID:-}" ] || [ "$(id -u)" != "0" ] || [ "$USER_ID" = "0" ]; then
	exec "$@"
fi

SOCKET=/var/run/docker.sock

# Adds a user to the member list of an existing group, once.
add_to_group() {
	if ! awk -F: -v group="$2" -v user="$1" \
		'$1 == group { n = split($4, members, ","); for (i = 1; i <= n; i++) if (members[i] == user) found = 1 } END { exit !found }' \
		/etc/group; then
		sed -i -e "s/^\($2:[^:]*:[^:]*:\)\(..*\)$/\1\2,$1/" -e "s/^\($2:[^:]*:[^:]*:\)$/\1$1/" /etc/group
	fi
}

# wp-env calls os.userInfo(), which fails for a UID without a passwd entry.
if ! getent group "$GROUP_ID" >/dev/null 2>&1; then
	echo "wokenv:x:$GROUP_ID:" >>/etc/group
fi
if ! getent passwd "$USER_ID" >/dev/null 2>&1; then
	echo "wokenv:x:$USER_ID:$GROUP_ID:Wokenv:${HOME:-/tmp}:/bin/sh" >>/etc/passwd
fi
USER_NAME=$(getent passwd "$USER_ID" | cut -d: -f1)

# Give the user access to the Docker socket through the socket's own group.
if [ -S "$SOCKET" ]; then
	SOCKET_GID=$(stat -c '%g' "$SOCKET")
	if ! getent group "$SOCKET_GID" >/dev/null 2>&1; then
		echo "docker-host:x:$SOCKET_GID:" >>/etc/group
	fi
	add_to_group "$USER_NAME" "$(getent group "$SOCKET_GID" | cut -d: -f1)"
fi

# su-exec resets HOME to the passwd entry: keep the one we were given.
exec su-exec "$USER_NAME" env HOME="${HOME:-/tmp}" "$@"
