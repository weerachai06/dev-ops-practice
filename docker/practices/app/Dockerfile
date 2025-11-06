FROM oven/bun:latest AS builder

# Metadata
LABEL maintainer="your-email@example.com"

WORKDIR /app

# Cache packages installation
COPY package.json package.json
COPY bun.lock bun.lock

RUN bun install

COPY ./src ./src

ENV NODE_ENV=production

RUN bun run build

FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=builder /app/dist/server ./server

ENV NODE_ENV=production

CMD ["./server"]

EXPOSE 3000