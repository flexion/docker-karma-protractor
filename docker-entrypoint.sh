#!/bin/bash

set -e

command="$1"

if [ "$command" == "no-bootstrap" ]; then
    exec bash
fi

if [ "$EUID" = "0" ]; then
    addgroup --gid $GROUP_ID karma
    adduser --quiet --gecos "" --uid $USER_ID --gid $GROUP_ID --home /home/karma --no-create-home --disabled-login --disabled-password karma

    echo "Starting X server"
    Xvfb :0 -screen 0 1500x3250x24 &
    sleep 2
    export DISPLAY=:0
    export HOME=/app
    su --preserve-environment --login karma --command "/docker-entrypoint.sh $*"
    exit $?
fi

export CHROME_BIN=/usr/bin/chromium-browser

echo "User: $(whoami) ($EUID)"
echo "COMMAND: $command"
echo "Node:   $(node --version)"
echo "NPM:    $(npm --version)"
echo "Yeoman: $(yo --version)"
echo "Bower:  $(bower --version)"
echo "Grunt:  $(grunt --version)"

cd /app

if [ "$RUN_NPM_INSTALL" = "true" ]; then
    echo "Running npm install"
    npm install
fi

if [ "$RUN_BOWER_INSTALL" = "true" ]; then
    echo "Running bower install"
    bower install --config.interactive=false
fi

if [ "$command" = "karma" ]; then
    shift
    echo "Launching 'grunt karma'"
#    export DISPLAY=:0
    DISPLAY=:0 grunt karma
    exit $?
elif [ "$command" = "protractor" ]; then
    shift
#    export DISPLAY=:0
    webdriver-manager start &
    sleep 2

    # check if Selenium server is listening @ port 4444
    if nc -z localhost 4444; then
        BASE_URL=$(echo $WEB_PORT | sed 's/tcp/http/')
        grunt protractor --baseUrl="$BASE_URL"
    else
        echo "Selenium server is not available"
        exit 1
    fi
fi

echo "[RUN]: Builtin command not provided [karma]"
echo "[RUN]: $@"

exec "$@"

