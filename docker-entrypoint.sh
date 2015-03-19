#!/bin/bash

command="$1"

echo "COMMAND: $command"

if [ "$command" = "karma" ]; then
    echo "Starting X server"
    Xvfb :0 &
    echo "Sleeping"
    sleep 10
    shift
    echo "Launching Karma, arguments: $*"
    DISPLAY=:0 /usr/local/lib/node_modules/karma/bin/karma start --single-run $*
    exit $?
fi

echo "[RUN]: Builtin command not provided [karma]"
echo "[RUN]: $@"

exec "$@"

