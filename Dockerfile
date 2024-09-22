

FROM node:22.9.0-slim

ARG IMAGE_CREATED
ARG IMAGE_REVISION
ARG GATSBY_VERSION=5.9.0

ENV GATSBY_VERSION=${GATSBY_VERSION}

# OCI Labels
LABEL org.opencontainers.image.title="Gatsby Container"
LABEL org.opencontainers.image.description="Optimized container for Gatsby with support for TypeScript, Vercel, and Netlify CLI."
LABEL org.opencontainers.image.authors="Adrian Freisinger <afreisinger@gmail.com>"
LABEL org.opencontainers.image.vendor="Adrian Freisinger"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="${GATSBY_VERSION}" 
LABEL org.opencontainers.image.source="https://github.com/afreisinger/gatsby-container"
LABEL org.opencontainers.image.documentation="https://docs.example.com/gatsby-container"
LABEL org.opencontainers.image.revision="${IMAGE_REVISION}" 
LABEL org.opencontainers.image.created="${IMAGE_CREATED}"

# Install dependencies and global npm packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl procps && \
    git config --global --add safe.directory /site && \
    npm install -g gatsby-cli@$GATSBY_VERSION typescript vercel netlify-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user and set permissions
RUN useradd -m -d /site user

WORKDIR /site

# Copy setup script
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Switch to non-root user
USER user

# Ensure ENTRYPOINT runs with non-root user permissions
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
