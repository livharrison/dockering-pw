#! /bin/bash

cd "$(dirname "$0")/.."
TIMESTAMP=$(date +%Y%m%d)


if pgrep -x "mongod" > /dev/null
then
    echo "MongoDB started"
else
    echo "MongoDB fail to start"
fi

# start web app
nohup python PW_run.py &>/dev/null &

# start caddy
nohup caddy -conf PW_Caddyfile &>/dev/null &


if pgrep -x "caddy" > /dev/null
then
    echo "Caddy started"
else
    echo "Caddy fail to start"
fi


if pgrep -x "mongod" > /dev/null && pgrep -x "caddy" > /dev/null
then
    echo "Project Wiki started"
else
    echo "Project Wiki fail to start"
fi
