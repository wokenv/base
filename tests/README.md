# Wokenv Base - Tests

## test.sh

Smoke test for a built image. It checks that:

- wp-env, git and Docker Compose are installed
- the Node.js version satisfies wp-env
- js-yaml resolves from the global modules
- the entrypoint runs commands as `USER_ID:GROUP_ID`, keeps `HOME` and gives that user access to the Docker socket

## Running Tests

```bash
docker build -t wokenv:test .
tests/test.sh wokenv:test
```

## Requirements

- Docker with a reachable daemon
- `/var/run/docker.sock`, or `DOCKER_SOCKET` set to the path of the socket

The build workflow runs this test for every image before pushing it.
