#!/bin/sh
set -e
set -o pipefail

error() { >&2 echo -e "${RED}Error: $@${RESET}"; }


# $PLUGIN_REPO          tag for the image to run and test
# $PLUGIN_DELAY         startup delay for the container before curl'ing it
# $PLUGIN_RETRY         curl retry count before giving up
# $PLUGIN_RETRY_DELAY   curl delay before retrying
# $PLUGIN_PIPE          shell code to execute on curl output. useful for ensuring output correctness
# $PLUGIN_CURL_OPTS     additional options to pass to curl
# $PLUGIN_RUN_ARGS      arguments to pass to `docker create`
# $PLUGIN_RUN_CMD       override docker container CMD

if [ -z "$PLUGIN_REPO" ]; then
    error "Missing 'repo' argument required for building"
fi


DELAY=${PLUGIN_DELAY:-10}
RETRY=${PLUGIN_RETRY:-5}
RETRY_DELAY=${PLUGIN_RETRY_DELAY:-5}


# Start the container
CONTAINER_ID="$(docker create --rm $PLUGIN_RUN_ARGS "$PLUGIN_REPO" $PLUGIN_RUN_CMD)"

# Exit if the container stops
trap 'error "The container exited unexpectedly :("; exit 10' USR1
( docker wait "$CONTAINER_ID" >/dev/null && kill -s USR1 $$ ) &

# Start the container and print the logs
docker start --attach "$CONTAINER_ID" &

# Get container IP, hopefully before the container exits
CONTAINER_IP="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)"
if [ -z "$CONTAINER_IP" ]; then
    docker kill "$CONTAINER_ID" >/dev/null 2>&1 || true
    docker rm -f "$CONTAINER_ID" >/dev/null 2>&1 || true
    error "No container IP found"
    exit 8
fi

# Wait
sleep $DELAY

# Attempt to curl
curl -sSL \
    --retry $RETRY \
    --retry-delay $RETRY_DELAY \
    --retry-max-time 10 \
    --retry-connrefused \
    $PLUGIN_CURL_OPTS \
    "$CONTAINER_IP$PLUGIN_CURL" \
        | tee /tmp/output

# Test the output
if [ -n "$PLUGIN_PIPE" ]; then
    eval $PLUGIN_PIPE < /tmp/output
fi
rm /tmp/output

# Remove the container
trap ':' USR1
docker kill "$CONTAINER_ID" >/dev/null 2>&1 || true
docker rm -f "$CONTAINER_ID" >/dev/null 2>&1 || true
