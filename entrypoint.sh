#!/bin/sh

set -eu

# If USER_ID and GROUP_ID are set, create user and switch to it
if [ -n "${USER_ID:-}" ] && [ -n "${GROUP_ID:-}" ]; then
	# Create group if it doesn't exist
	if ! getent group "$GROUP_ID" >/dev/null 2>&1; then
		addgroup -g "$GROUP_ID" hostuser 2>/dev/null || true
	fi

	# Get the group name
	GROUP_NAME=$(getent group "$GROUP_ID" | cut -d: -f1)

	# Create user if it doesn't exist
	if ! id -u "$USER_ID" >/dev/null 2>&1; then
		adduser -D -u "$USER_ID" -G "$GROUP_NAME" hostuser 2>/dev/null || true
	fi

	# Get the user name
	USER_NAME=$(getent passwd "$USER_ID" | cut -d: -f1)

	# Add user to docker group if docker socket is mounted
	if [ -S /var/run/docker.sock ]; then
		DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
		# Create docker group with the same GID as the socket
		if ! getent group "$DOCKER_GID" >/dev/null 2>&1; then
			addgroup -g "$DOCKER_GID" docker 2>/dev/null || true
		fi
		# Add user to docker group
		DOCKER_GROUP=$(getent group "$DOCKER_GID" | cut -d: -f1)
		addgroup "$USER_NAME" "$DOCKER_GROUP" 2>/dev/null || true
	fi

	# Switch to the user and execute command, preserving USER_ID and GROUP_ID
	exec su-exec "$USER_NAME" env USER_ID="$USER_ID" GROUP_ID="$GROUP_ID" "$@"
else
	# No USER_ID/GROUP_ID set, just execute as current user (root)
	exec "$@"
fi
