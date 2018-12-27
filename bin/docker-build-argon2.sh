#!/usr/bin/env bash
docker build \
    --file docker/argon2/Dockerfile \
    --tag watcoin:argon2 \
    .
