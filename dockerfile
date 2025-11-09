FROM node:20-slim

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential ca-certificates git \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./

RUN if [ "$NODE_ENV" = "production" ]; then npm ci --omit=dev; else npm ci; fi

COPY . .

RUN useradd --create-home --shell /bin/bash appuser \
    && chown -R appuser:appuser /app
USER appuser

EXPOSE 3000

CMD ["npm", "start"]