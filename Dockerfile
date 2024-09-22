# Stage 1: Build stage
FROM node:22.9.0-slim AS build

# OCI Labels for the build stage
LABEL stage="build"
LABEL org.opencontainers.image.title="Gatsby Build Container"
LABEL org.opencontainers.image.description="Build stage container for Gatsby with TypeScript, Vercel, and Netlify CLI."
LABEL org.opencontainers.image.authors="Adrian Freisinger <afreisinger@gmail.com>"
LABEL org.opencontainers.image.licenses="MIT"

# Install dependencies and global npm packages
ARG GATSBY_CLI_VERSION=5.9.0
ARG IMAGE_CREATED
ARG IMAGE_REVISION


RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl procps && \
    git config --global --add safe.directory /site && \
    npm install -g gatsby-cli@$GATSBY_CLI_VERSION typescript vercel netlify-cli npm@latest && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Stage 2: Final stage
FROM node:22.9.0-slim

# OCI Labels for the final image
LABEL stage="final"
LABEL org.opencontainers.image.title="Gatsby Container"
LABEL org.opencontainers.image.description="Optimized container for Gatsby with support for TypeScript, Vercel, and Netlify CLI."
LABEL org.opencontainers.image.authors="Adrian Freisinger <afreisinger@gmail.com>"
LABEL org.opencontainers.image.vendor="Adrian Freisinger"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="${GATSBY_CLI_VERSION}"
LABEL org.opencontainers.image.source="https://github.com/afreisinger/gatsby-container"
LABEL org.opencontainers.image.documentation="https://docs.example.com/gatsby-container"
LABEL org.opencontainers.image.revision="${IMAGE_REVISION}" 
LABEL org.opencontainers.image.created="${IMAGE_CREATED}" 

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



# Stage 1: Build stage
# FROM node:22.9.0-slim AS build

# # Install dependencies and global npm packages
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends git curl procps && \
#     git config --global --add safe.directory /site && \
#     npm install -g gatsby-cli typescript vercel netlify-cli npm@latest && \
#     apt-get clean && rm -rf /var/lib/apt/lists/*

# # Update npm to the latest version
# #RUN npm install -g npm@latest

# # Stage 2: Final stage
# FROM node:22.9.0-slim

# # Install dependencies and copy global npm packages from the build stage
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends git curl procps && \
#     #npm install -g npm@latest && \
#     apt-get clean && rm -rf /var/lib/apt/lists/*

# # Copy global npm packages and libraries from the build stage
# COPY --from=build /usr/local/bin /usr/local/bin
# COPY --from=build /usr/local/lib /usr/local/lib

# WORKDIR /site

# # Copy setup script
# COPY entrypoint.sh /usr/bin/entrypoint.sh
# RUN chmod +x /usr/bin/entrypoint.sh

# ENTRYPOINT ["/usr/bin/entrypoint.sh"]

