[![Docker Pulls](https://img.shields.io/docker/pulls/frugan/wokenv)](https://hub.docker.com/r/frugan/wokenv)
[![Docker Image Size](https://img.shields.io/docker/image-size/frugan/wokenv/latest)](https://hub.docker.com/r/frugan/wokenv)
[![Build Status](https://github.com/wokenv/base/actions/workflows/docker-build.yml/badge.svg)](https://github.com/wokenv/base/actions/workflows/docker-build.yml)
[![GitHub Release](https://img.shields.io/github/v/release/wokenv/base)](https://github.com/wokenv/base/releases)
[![License](https://img.shields.io/github/license/wokenv/base)](https://github.com/wokenv/base/blob/main/LICENSE)

# Wokenv Docker Images

Docker images for [Wokenv](https://github.com/wokenv/wokenv) - WordPress development environment with Node.js, Docker, and [@wordpress/env](https://developer.wordpress.org/block-editor/reference-guides/packages/packages-env/) package ([wp-env](https://github.com/WordPress/gutenberg/tree/trunk/packages/env)) pre-configured.

## Available Images

Images published to Docker Hub: [`frugan/wokenv`](https://hub.docker.com/r/frugan/wokenv)

**Variants:**
- **Alpine** (recommended) - Lightweight, minimal footprint
- **Bookworm** (Debian 12) - Stable, full-featured
- **Trixie** (Debian 13) - Testing, latest features

**Node.js versions:** 18, 20 (LTS), 22

**wp-env version:** 10 (major)

## Tag Strategy

### Full Tags
Format: `node{VERSION}-{VARIANT}-wpenv{VERSION}`

```bash
# Alpine variants (default)
frugan/wokenv:node20-alpine-wpenv10
frugan/wokenv:node22-alpine-wpenv10
frugan/wokenv:node18-alpine-wpenv10

# Bookworm (Debian 12) variants
frugan/wokenv:node20-bookworm-wpenv10
frugan/wokenv:node22-bookworm-wpenv10

# Trixie (Debian 13) variants
frugan/wokenv:node20-trixie-wpenv10
frugan/wokenv:node22-trixie-wpenv10
```

### Short Tags (Alpine only)
Format: `node{VERSION}-wpenv{VERSION}`

```bash
frugan/wokenv:node20-wpenv10   # Same as node20-alpine-wpenv10
frugan/wokenv:node22-wpenv10
```

### Rolling Tags

```bash
frugan/wokenv:latest            # node20-alpine-wpenv10 (recommended)
frugan/wokenv:node20-latest     # Latest wpenv for Node 20
frugan/wokenv:node22-latest     # Latest wpenv for Node 22
frugan/wokenv:node20-lts        # Node 20 LTS (Bookworm variant)
```

**Note:** Tags are updated daily with latest OS patches and wp-env updates within the same major version.

## Quick Start

```bash
# Pull latest image
docker pull frugan/wokenv:latest

# Or specific version
docker pull frugan/wokenv:node20-wpenv10

# Or specific variant
docker pull frugan/wokenv:node20-trixie-wpenv10
```

See [Wokenv documentation](https://github.com/wokenv/wokenv) for usage instructions.

## What's Included

- Node.js (18, 20, or 22)
- npm
- Docker CLI and Docker Compose
- Git
- wp-env (pre-installed with patches)
- Automatic UID/GID permission handling

## Important Notes

### Docker User Namespace Remapping

⚠️ **These images are NOT compatible with Docker `userns-remap` configurations.**

If you have `userns-remap` enabled in your Docker daemon configuration (`/etc/docker/daemon.json`), you will experience permission issues. This is because wp-env requires specific user permissions that conflict with namespace remapping.

The `entrypoint.sh` script handles user/group ID mapping, but this approach is incompatible with Docker's user namespace remapping feature.

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
- When wp-env major version changes (e.g., 10.x → 11.0), new tags are created

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
