#!/usr/bin/env bash
docker build \
    --tag watcoin:bitcoind \
    --file docker/bitcoind/Dockerfile \
    .
