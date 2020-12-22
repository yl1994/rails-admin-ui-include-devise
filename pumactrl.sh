#!/bin/bash

case "$1" in
    "")
        echo -n "starting puma..."
        puma
        ;;
    start)
        echo -n "starting puma..."
        puma
        ;;
    stop)
        echo "stoping puma..."
        kill `cat "shared/pids/puma.pid"`
        ;;
    reload)
        echo "reloading puma..."
        kill `cat "shared/pids/puma.pid"`
        puma
        ;;
esac
