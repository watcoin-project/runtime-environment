#!/usr/bin/env bash

docker image inspect watcoin:argon2 &>/dev/null
if [ "$?" != "0" ]
then
    dir=$(dirname $(realpath "$0"))
    $(echo "$dir/docker-build-argon2.sh")
fi

docker-compose build \
    cpuminer
