# Wokenv Docker Image
# Node.js + Docker CLI + @wordpress/env (wp-env), ready to drive the host's
# Docker daemon on behalf of the wokenv CLI.

# wp-env 12 requires Node.js >= 22.13
ARG NODE_VERSION=24

FROM node:${NODE_VERSION}-alpine

ARG WPENV_VERSION=12

# - docker-cli, docker-cli-compose: wp-env shells out to `docker compose`
# - git: wp-env clones WordPress, plugins and themes
# - su-exec: drop privileges to the host user in the entrypoint
# hadolint ignore=DL3018
RUN apk add --no-cache \
        bash \
        docker-cli \
        docker-cli-compose \
        git \
        su-exec

# js-yaml lets the wokenv CLI read wokenv.yml inside this image, so the host
# needs no YAML parser. Global modules are resolved through NODE_PATH.
# hadolint ignore=DL3016
RUN npm install -g "@wordpress/env@${WPENV_VERSION}" js-yaml@4 \
    && npm cache clean --force
ENV NODE_PATH=/usr/local/lib/node_modules

COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["wp-env", "--help"]

# Metadata
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.authors="Frugan" \
      org.opencontainers.image.url="https://github.com/wokenv/base" \
      org.opencontainers.image.documentation="https://github.com/wokenv/wokenv" \
      org.opencontainers.image.source="https://github.com/wokenv/base" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.vendor="Wokenv" \
      org.opencontainers.image.title="Wokenv" \
      org.opencontainers.image.description="WordPress development environment with Node.js, Docker, and @wordpress/env package pre-configured"
