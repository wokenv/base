#!/bin/bash

# shellcheck disable=SC2016,SC2329

# Smoke test for a built Wokenv image.
# Usage: tests/test.sh <image>

set -euo pipefail

IMAGE="${1:?Usage: tests/test.sh <image>}"
SOCKET="${DOCKER_SOCKET:-/var/run/docker.sock}"
FAILED=0

check() {
	local description="$1"
	shift
	if "$@" >/dev/null 2>&1; then
		echo "✓ $description"
	else
		echo "✗ $description"
		FAILED=1
	fi
}

as_user() {
	docker run --rm -e USER_ID=12345 -e GROUP_ID=23456 -e HOME=/tmp \
		-v "$SOCKET:/var/run/docker.sock" "$IMAGE" "$@"
}

check "wp-env is installed" docker run --rm "$IMAGE" wp-env --version
check "Node.js satisfies wp-env" docker run --rm "$IMAGE" node -e \
	"const [a, b] = process.versions.node.split('.').map(Number); process.exit(a > 22 || (a === 22 && b >= 13) ? 0 : 1)"
check "js-yaml resolves globally" docker run --rm "$IMAGE" node -e "require('js-yaml')"
check "git is installed" docker run --rm "$IMAGE" git --version
check "docker compose is installed" docker run --rm "$IMAGE" docker compose version
check "runs as root without USER_ID" docker run --rm "$IMAGE" sh -c '[ "$(id -u)" = 0 ]'
check "drops to USER_ID:GROUP_ID" as_user sh -c '[ "$(id -u):$(id -g)" = 12345:23456 ]'
check "keeps HOME" as_user sh -c '[ "$HOME" = /tmp ]'
check "os.userInfo() works for the mapped user" as_user node -e "require('os').userInfo()"
check "mapped user reaches the Docker daemon" as_user docker version

exit "$FAILED"
