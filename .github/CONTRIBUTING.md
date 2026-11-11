# Contributing to Wokenv Images

Thank you for your interest in contributing to Wokenv Images!

## Repository Structure

This repository contains Docker images for [Wokenv](https://github.com/wokenv/wokenv).

```
base/
├── Dockerfile              # Image definition
├── entrypoint.sh          # Container entrypoint
├── tests/
│   └── test.sh            # Smoke test for a built image
├── .github/workflows/
│   └── build.yml   # Build automation
└── .last-built-wpenv      # Version tracker
```

## How to Contribute

### Reporting Issues

- **Image-specific bugs**: Open an issue here
- **Usage/CLI issues**: Open an issue in [wokenv/wokenv](https://github.com/wokenv/wokenv/issues)

When reporting:
- Specify which image tag you're using
- Include Docker version: `docker version`
- Provide steps to reproduce

### Proposing Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test locally (see below)
5. Submit a pull request

## Testing Locally

### Build Test Image

```bash
docker build \
  --build-arg NODE_VERSION=24 \
  --build-arg WPENV_VERSION=12 \
  -t wokenv:test \
  .
```

### Test the Image

```bash
# Smoke test: tools, user mapping, access to the Docker socket
tests/test.sh wokenv:test

# Test with an actual project, through the wokenv command
cd /path/to/test-project
WOKENV_IMAGE=wokenv:test wokenv start
```

## Adding New Node Versions

To add support for a new Node.js version:

1. Update the matrix in `.github/workflows/build.yml`:
   ```yaml
   matrix:
     node: [22, 24, 26]  # Add new version
   ```

2. Test locally first:
   ```bash
   docker build --build-arg NODE_VERSION=26 -t wokenv:node26-test .
   tests/test.sh wokenv:node26-test
   ```

3. Submit PR with justification for new version

## wp-env Is Not Patched

Earlier versions of this image patched wp-env's sources, and every patch broke when wp-env moved its files. Do not reintroduce patches: wp-env must work unmodified, driven only through its configuration, its command line and environment variables such as `WP_ENV_HOME`.

## Code Style

- Use clear, descriptive comments
- Follow existing patterns in Dockerfile
- Keep `entrypoint.sh` POSIX sh: it must not depend on adduser/useradd flavours
- Test on both amd64 and arm64 (if possible)

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
feat: add Node.js 24 support
fix: correct entrypoint permissions
docs: update README with new tags
chore: update dependencies
```

## Build Workflow

Understanding the automated build:

1. **Daily Check** (2:00 AM UTC):
   - Checks npm for latest wp-env version
   - Compares with `.last-built-wpenv`
   - Builds only if version changed

2. **On Push** (main branch):
   - Builds all matrix variants
   - Pushes to Docker Hub
   - Updates tags

3. **Manual Trigger**:
   - Use "Actions" tab → "Run workflow"
   - Option to force build all

## Testing Matrix Builds

To test the full matrix locally:

```bash
#!/bin/bash
for node in 18 20 22; do
  for variant in alpine bookworm; do
    echo "Building node${node}-${variant}"
    docker build \
      --build-arg NODE_VERSION=$node \
      --build-arg NODE_VARIANT=$variant \
      --build-arg WPENV_VERSION=10 \
      -t wokenv:node${node}-${variant}-test \
      .
  done
done
```

## Release Process

This repository doesn't use semantic versioning. Instead:

- Image tags track Node + wp-env versions
- Changes are continuous
- No formal "releases"

The main repo ([wokenv/wokenv](https://github.com/wokenv/wokenv)) handles versioning.

## Questions?

- Open a [Discussion](https://github.com/wokenv/base/discussions)
- Check main [Wokenv Documentation](https://github.com/wokenv/wokenv)

## License

By contributing, you agree your contributions will be licensed under GPL-3.0-or-later.
