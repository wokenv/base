# Wokenv Docker Image
# Multi-stage build supporting multiple Node versions and variants

# Build arguments
ARG NODE_VERSION=20
ARG NODE_VARIANT=alpine

# Base stage
FROM node:${NODE_VERSION}-${NODE_VARIANT} AS base

# Install system dependencies based on variant
# hadolint ignore=DL3018,DL3008
RUN if [ "${NODE_VARIANT}" = "alpine" ]; then \
        apk add --no-cache \
            docker-cli \
            docker-cli-compose \
            git \
            shadow \
            su-exec; \
    else \
        apt-get update && apt-get install -y --no-install-recommends \
            docker.io \
            docker-compose \
            git \
            sudo \
        && rm -rf /var/lib/apt/lists/*; \
    fi

# Create node user with specific UID/GID if not exists
RUN if ! id node > /dev/null 2>&1; then \
        if [ "${NODE_VARIANT}" = "alpine" ]; then \
            addgroup -g 1000 node && \
            adduser -D -u 1000 -G node node; \
        else \
            groupadd -g 1000 node && \
            useradd -u 1000 -g node -m node; \
        fi; \
    fi

# Create /home/node directory and make it world-writable
RUN mkdir -p /home/node && chmod 777 /home/node

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create app directory
WORKDIR /app

# Install wp-env and patch-package globally
ARG WPENV_VERSION=10
# hadolint ignore=DL3016
RUN npm install -g @wordpress/env@${WPENV_VERSION} patch-package

# Copy and apply patches
COPY patches /tmp/patches
# hadolint ignore=DL3003
RUN if [ -d /tmp/patches ]; then \
        NPM_ROOT=$(npm root -g) && \
        cd "$NPM_ROOT" && \
        cp -r /tmp/patches/* . && \
        npx patch-package && \
        rm -rf /tmp/patches; \
    fi

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command
CMD ["sh"]

# Metadata
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.authors="Wokenv Team" \
      org.opencontainers.image.url="https://github.com/wokenv/base" \
      org.opencontainers.image.documentation="https://github.com/wokenv/wokenv" \
      org.opencontainers.image.source="https://github.com/wokenv/base" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.vendor="Wokenv" \
      org.opencontainers.image.title="Wokenv" \
      org.opencontainers.image.description="WordPress development environment with Node.js, Docker, and wp-env"
