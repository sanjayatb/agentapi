#!/usr/bin/env sh
set -eu

PORT=${AGENTAPI_PORT:-3284}
ALLOWED_HOSTS=${AGENTAPI_ALLOWED_HOSTS:-*}
ALLOWED_ORIGINS=${AGENTAPI_ALLOWED_ORIGINS:-*}
AGENT_TYPE=${AGENTAPI_AGENT_TYPE:-custom}
TERM_WIDTH=${AGENTAPI_TERM_WIDTH:-160}
TERM_HEIGHT=${AGENTAPI_TERM_HEIGHT:-48}
BACKING_COMMAND=${AGENTAPI_BACKING_COMMAND:-bash}

HOSTS_FLAG=$(printf "%s" "${ALLOWED_HOSTS}" | tr ' ' ',')
ORIGINS_FLAG=$(printf "%s" "${ALLOWED_ORIGINS}" | tr ' ' ',')

set -- agentapi server \
  --port "${PORT}" \
  --type "${AGENT_TYPE}" \
  --allowed-hosts "${HOSTS_FLAG}" \
  --allowed-origins "${ORIGINS_FLAG}" \
  --term-width "${TERM_WIDTH}" \
  --term-height "${TERM_HEIGHT}" \
  -- sh -c "${BACKING_COMMAND}"

exec "$@"
