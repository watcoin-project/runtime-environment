#!/usr/bin/env bash
docker-compose run \
    -e uid=$(id -u) \
    -e gid=$(id -g) \
    -e DISPLAY=$DISPLAY \
    qt
