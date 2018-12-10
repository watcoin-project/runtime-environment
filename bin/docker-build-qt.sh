#!/usr/bin/env bash
docker build \
    --tag watcoin:qt \
    --file docker/qt/Dockerfile \
    .
