# Stage 1: Build stage
FROM node:22.9.0-slim AS build

ARG IMAGE_VERSION
ENV GATSBY_VERSION=${IMAGE_VERSION}

# Install dependencies and global npm packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl procps && \
    git config --global --add safe.directory /site && \
    npm install -g gatsby-cli@${GATSBY_VERSION} typescript vercel netlify-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Stage 2: Final stage
FROM node:22.9.0-slim

# Install dependencies and copy global npm packages from the build stage
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl procps && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy global npm packages and libraries from the build stage
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/lib /usr/local/lib

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