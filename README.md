[![Docker Pulls](https://img.shields.io/docker/pulls/frugan/wokenv)](https://hub.docker.com/r/frugan/wokenv)
[![Docker Image Size](https://img.shields.io/docker/image-size/frugan/wokenv/latest)](https://hub.docker.com/r/frugan/wokenv)
[![Build Status](https://github.com/wokenv/base/actions/workflows/build.yml/badge.svg)](https://github.com/wokenv/base/actions/workflows/build.yml)
[![GitHub Release](https://img.shields.io/github/v/release/wokenv/base)](https://github.com/wokenv/base/releases)
[![License](https://img.shields.io/github/license/wokenv/base)](https://github.com/wokenv/base/blob/main/LICENSE)

# Wokenv Docker Images

Docker images for [Wokenv](https://github.com/wokenv/wokenv) - WordPress development environment with Node.js, Docker, and [@wordpress/env](https://developer.wordpress.org/block-editor/reference-guides/packages/packages-env/) package ([wp-env](https://github.com/WordPress/gutenberg/tree/trunk/packages/env)) pre-configured.

## Available Images

Images published to Docker Hub: [`frugan/wokenv`](https://hub.docker.com/r/frugan/wokenv)

**Base:** Alpine Linux

**Node.js versions:** 22, 24 (default)

**wp-env version:** 12 (major). wp-env 12 requires Node.js 22.13 or later.

## Tag Strategy

| Tag               | Example          | Description                                         |
| ----------------- | ---------------- | --------------------------------------------------- |
| `latest`          | `latest`         | Default Node.js version, latest wp-env (recommended) |
| `node{N}`         | `node24`         | Latest wp-env for a Node.js version                 |
| `node{N}-wpenv{M}` | `node24-wpenv12` | A Node.js version with a wp-env major version       |

Tags with a `-alpine`, `-bookworm` or `-trixie` variant and tags for Node.js 18 and 20 belong to earlier releases and are no longer updated.

## Quick Start

These images are meant to be used through the [`wokenv`](https://github.com/wokenv/wokenv) command, which mounts what wp-env needs. To select an image in a project:

```yaml
# wokenv.yml
image: frugan/wokenv:node22
```

## What's Included

- Node.js and npm
- Docker CLI and Docker Compose
- Git
- wp-env, unmodified
- js-yaml, used by the `wokenv` command to read `wokenv.yml`
- An entrypoint that runs commands as the host user

### The entrypoint

When `USER_ID` and `GROUP_ID` are set, the entrypoint creates that user, adds it to the group that owns `/var/run/docker.sock` and runs the command as that user. wp-env then builds its images for the right user, and files created in mounted directories keep the right owner. Without those variables the command runs as root.

## Important Notes

### Docker User Namespace Remapping

⚠️ **These images are NOT compatible with Docker `userns-remap` configurations.**

If you have `userns-remap` enabled in your Docker daemon configuration (`/etc/docker/daemon.json`), you will experience permission issues. This is because wp-env requires specific user permissions that conflict with namespace remapping.

The `entrypoint.sh` script maps the host user into the container, but this approach is incompatible with Docker's user namespace remapping feature.

**To check if you have userns-remap enabled:**
```bash
docker info | grep "userns"
```

**If you need user namespace remapping for security, these images are not suitable for your setup.**

## Platforms

- linux/amd64 (Intel/AMD)
- linux/arm64 (Apple Silicon, ARM)

## Update Strategy

Images are rebuilt daily to include:
- Latest OS security patches
- Latest wp-env updates within same major version
- When wp-env major version changes (e.g., 12.x → 13.0), new tags are created

Every image is tested with `tests/test.sh` before it is pushed.

## Documentation

- [Wokenv Documentation](https://github.com/wokenv/wokenv)
- [Wokenv Docker Hub](https://hub.docker.com/r/frugan/wokenv)
- [wp-env Documentation](https://developer.wordpress.org/block-editor/reference-guides/packages/packages-env/)

## Contributing

For your contributions please use:

- [Conventional Commits](https://www.conventionalcommits.org)
- [Pull request workflow](https://docs.github.com/en/get-started/exploring-projects-on-github/contributing-to-a-project)

See [CONTRIBUTING](.github/CONTRIBUTING.md) for detailed guidelines.

## Sponsor

[<img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" width="200" alt="Buy Me A Coffee">](https://buymeacoff.ee/frugan)

## License

(ɔ) Copyleft 2026 [Frugan](https://frugan.it).  
[GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/), see [LICENSE](LICENSE) file.
