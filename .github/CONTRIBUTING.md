# Contributing to Wokenv Images

Thank you for your interest in contributing to Wokenv Images!

## Repository Structure

This repository contains Docker images for [Wokenv](https://github.com/wokenv/wokenv).

```
base/
├── Dockerfile              # Multi-stage Dockerfile
├── entrypoint.sh          # Container entrypoint
├── patches/               # wp-env patches
│   └── @wordpress_env_*.patch
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
  --build-arg NODE_VERSION=20 \
  --build-arg NODE_VARIANT=alpine \
  --build-arg WPENV_VERSION=10 \
  -t wokenv:test \
  .
```

### Test the Image

```bash
# Test entrypoint
docker run --rm wokenv:test sh -c "echo 'Test successful'"

# Test wp-env installation
docker run --rm wokenv:test sh -c "wp-env --version"

# Test Docker CLI
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  wokenv:test \
  sh -c "docker version"

# Test with actual project
cd /path/to/test-project
docker run --rm -it \
  -v "$(pwd):$(pwd)" \
  -v "$HOME/.wp-env:/home/node/.wp-env" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w "$(pwd)" \
  -e USER_ID=$(id -u) \
  -e GROUP_ID=$(id -g) \
  wokenv:test \
  npx wp-env start
```

## Adding New Node Versions

To add support for a new Node.js version:

1. Update the matrix in `.github/workflows/build.yml`:
   ```yaml
   matrix:
     node: [18, 20, 22, 24]  # Add new version
   ```

2. Test locally first:
   ```bash
   docker build --build-arg NODE_VERSION=24 -t wokenv:node24-test .
   ```

3. Submit PR with justification for new version

## Updating wp-env Patches

When a new wp-env version is released that breaks the patch:

1. Test the current patch against new version
2. Update patch file in `patches/`
3. Update patch filename to reflect version
4. Update Dockerfile `COPY` command if needed
5. Test thoroughly
6. Document changes in PR

### Creating a New Patch

```bash
# Install specific wp-env version
npm install -g @wordpress/env@10.37.0

# Navigate to node_modules
cd $(npm root -g)

# Make changes to fix issues
vim @wordpress/env/lib/get-host-user.js

# Generate patch
npx patch-package @wordpress/env

# Copy patch to repository
cp patches/@wordpress_env*.patch /path/to/base/patches/
```

## Code Style

- Use clear, descriptive comments
- Follow existing patterns in Dockerfile
- Keep Alpine and Bookworm variants compatible
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
