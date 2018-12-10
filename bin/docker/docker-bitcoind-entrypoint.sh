#!/usr/bin/env bash

function exit_message {
    (>&2 echo "$@")
    exit 1
}

function add_or_modify_line {
    filepath=$1
    name=$2
    value=$3

    if [ -f "$filepath" ] && [ "$(cat "$filepath" | grep "^$name=" | wc -l)" -gt "0" ]
    then
        sed -i "s/$name=.*/$name=$value/" $filepath
    else
        echo "$name=$value" >> $filepath
    fi
}

function remove_line {
    filepath=$1
    name=$2

    sed -i "/$name=.*/d" $filepath
}

if [ -z "$BITCOIN_PORT" ]
then
    exit_message "BITCOIN_PORT not set!"
fi

if [ -z "$BITCOIN_RPC_PORT" ]
then
    exit_message "BITCOIN_RPC_PORT not set!"
fi

if [ -z "$BITCOIN_DATA_DIR" ]
then
    exit_message "BITCOIN_DATA_DIR not set!"
fi

BITCOIN_CONF_FILE="$BITCOIN_DATA_DIR/bitcoin.conf"
echo $BITCOIN_CONF_FILE

if [ -n "$BITCOIN_RPC_USER" ] && [ -z "$BITCOIN_RPC_PASSWORD" ]
then
    exit_message "BITCOIN_RPC_PASSWORD not set for BITCOIN_RPC_USER!"
fi

mkdir -p "$BITCOIN_DATA_DIR" &>/dev/null
if [ "$?" != "0" ]
then
    exit_message "Failed to create \"$BITCOIN_DATA_DIR\"!"
fi

echo "port=$BITCOIN_PORT"
add_or_modify_line $BITCOIN_CONF_FILE port $BITCOIN_PORT

echo "rpcport=$BITCOIN_RPC_PORT"
add_or_modify_line $BITCOIN_CONF_FILE rpcport $BITCOIN_RPC_PORT

if [ -n "$BITCOIN_RPC_USER" ] && [ -n "$BITCOIN_RPC_PASSWORD" ]
then
    add_or_modify_line $BITCOIN_CONF_FILE rpcuser $BITCOIN_RPC_USER
    add_or_modify_line $BITCOIN_CONF_FILE rpcpassword $BITCOIN_RPC_PASSWORD
else
    remove_line $BITCOIN_CONF_FILE rpcuser
    remove_line $BITCOIN_CONF_FILE rpcpassword
fi

if [ -n "$BITCOIN_RPC_DEPRECATED" ]
then
    add_or_modify_line $BITCOIN_CONF_FILE deprecatedrpc $BITCOIN_RPC_DEPRECATED
else
    remove_line $BITCOIN_CONF_FILE deprecatedrpc
fi

if [ "$BITCOIN_SERVER" == "1" ]
then
    add_or_modify_line $BITCOIN_CONF_FILE server 1
else
    remove_line $BITCOIN_CONF_FILE server
fi

if [ "$BITCOIN_REGTEST" == "1" ]
then
    add_or_modify_line $BITCOIN_CONF_FILE regtest 1
else
    remove_line $BITCOIN_CONF_FILE regtest
fi

remove_line $BITCOIN_CONF_FILE connect
if [ -n "$BITCOIN_CONNECT" ]
then 
    for connect in $BITCOIN_CONNECT
    do
        echo "connect=$connect" >> "$BITCOIN_CONF_FILE"
    done
fi

remove_line $BITCOIN_CONF_FILE addnode
if [ -n "$BITCOIN_ADD_NODE" ]
then
    for node in $BITCOIN_ADD_NODE
    do
        echo "addnode=$node" >> "$BITCOIN_CONF_FILE"
    done
fi

flags="-datadir=$BITCOIN_DATA_DIR -conf=$BITCOIN_CONF_FILE"

if [ "BITCOIN_ENABLE_DNS" == "1" ]
then
    flags="$flags -dns"
fi

eval "bitcoind $flags $@"
