FROM golang:1.23.2-bookworm AS builder

WORKDIR /workspace

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN mkdir -p /workspace/bin \
  && CGO_ENABLED=0 GOOS=linux go build -o /workspace/bin/agentapi

FROM debian:bookworm-slim AS runtime

ENV AGENTAPI_PORT=3284 \
    AGENTAPI_ALLOWED_HOSTS=* \
    AGENTAPI_ALLOWED_ORIGINS=* \
    AGENTAPI_AGENT_TYPE=custom \
    AGENTAPI_BACKING_COMMAND=bash

RUN apt-get update \
  && apt-get install --no-install-recommends -y ca-certificates bash \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /workspace/bin/agentapi /usr/local/bin/agentapi
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 3284

ENTRYPOINT ["/entrypoint.sh"]
