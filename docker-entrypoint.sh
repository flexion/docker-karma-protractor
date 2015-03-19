#!/bin/bash

command="$1"

echo "COMMAND: $command"

if [ "$command" = "karma" ]; then
    shift

    bowerfile="$1"
    shift
    echo "installing bower dependencies from file: $bowerfile"
    (mkdir /bower &&
        cd /bower &&
        cp "$bowerfile" . &&
        bower install --allow-root --config.interactive=false)

    echo "Starting X server"
    Xvfb :0 &
    sleep 2

    echo "Launching Karma, arguments: $*"
    DISPLAY=:0 /usr/local/lib/node_modules/karma/bin/karma start --single-run $*
    exit $?
fi

echo "[RUN]: Builtin command not provided [karma]"
echo "[RUN]: $@"

exec "$@"

