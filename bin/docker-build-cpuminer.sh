#!/usr/bin/env bash
docker build \
    --file docker/cpuminer/Dockerfile \
    --tag watcoin:cpuminer \
    .
