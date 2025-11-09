# Node.js + npm Dockerfile (replaces previous Python-based Dockerfile)rfile (replaces previous Python-based Dockerfile)

FROM node:20-slimFROM node:20-slim

# Default environment (override with --build-arg NODE_ENV=development)# Default environment (override with --build-arg NODE_ENV=development)
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}}

WORKDIR /appWORKDIR /app

# Install small deps for native modules if needed# Install small deps for native modules if needed
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential ca-certificates git \ll -y --no-install-recommends build-essential ca-certificates git \
    && rm -rf /var/lib/apt/lists/*

# Copy package manifests first to leverage layer caching# Copy package manifests first to leverage layer caching
COPY package*.json ./

# Use npm ci for reproducible installs; omit dev deps in production builds# Use npm ci for reproducible installs; omit dev deps in production builds
RUN if [ "$NODE_ENV" = "production" ]; then npm ci --omit=dev; else npm ci; fi; fi

# Copy app source# Copy app source
COPY . .

# Create non-root user and set ownership# Create non-root user and set ownership
RUN useradd --create-home --shell /bin/bash appuser \ash appuser \
    && chown -R appuser:appuser /app
USER appuser

# Expose default app port (update if your app uses a different port)# Expose default app port (update if your app uses a different port)
EXPOSE 3000

# Start the app using the README's start script# Start the app using the README's start script
CMD ["npm", "start"]