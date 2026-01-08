# Wokenv Base - Tests

Unit tests for Docker image builds.

## Available Tests

### build.sh

Tests all Docker image variants (Alpine, Bookworm, Trixie).

## Running Tests

```bash
# From repository root
./tests/build.sh

# Or from tests directory
cd tests
./build.sh
```

## What's Tested

- **Alpine variant**: Lightweight Node.js image
- **Bookworm variant**: Debian 12 stable
- **Trixie variant**: Debian 13 testing
- **Docker CLI**: Socket accessibility and functionality
- **wp-env**: Correct installation and patching

## Requirements

- Docker daemon running
- Docker socket accessible at `/var/run/docker.sock`
- Sufficient disk space for building 3 images

## Test Output

The script will build all three variants and verify:
1. Build succeeds without errors
2. Docker CLI is accessible
3. wp-env is correctly installed and responds

All build output is displayed during execution.
