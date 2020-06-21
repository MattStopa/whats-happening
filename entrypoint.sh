#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails. (got to comment this out to work in openshift)
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"