#!/usr/bin/env bash

function exit_message {
    (>&2 echo "$@")
    exit 1
}

function add_or_modify_line {
    filepath=$1
    name=$2
    value=$3

    if [ -f "$filepath" ] && [ "$(cat "$filepath" | grep "^\(?:$PREFIX\|\)$name=" | wc -l)" -gt "0" ]
    then
        sed -i "s/^\(?:$PREFIX\|\)$name=.*/$PREFIX$name=$value/" $filepath
    else
        echo "$PREFIX$name=$value" >> $filepath
    fi
}

function remove_line {
    filepath=$1
    name=$2

    if [ -f "$filepath" ]
    then
        sed -i "/^\(?:$PREFIX\|\)$name=.*/d" $filepath
    fi
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

if [ -n "$BITCOIN_RPC_USER" ] && [ -z "$BITCOIN_RPC_PASSWORD" ]
then
    exit_message "BITCOIN_RPC_PASSWORD not set for BITCOIN_RPC_USER!"
fi

mkdir -p "$BITCOIN_DATA_DIR" &>/dev/null
if [ "$?" != "0" ]
then
    exit_message "Failed to create \"$BITCOIN_DATA_DIR\"!"
fi

remove_line $BITCOIN_CONF_FILE testnet
remove_line $BITCOIN_CONF_FILE regtest
if [ -f "$BITCOIN_CONF_FILE" ]
then
    sed -i "/\[regtest\]/d" $BITCOIN_CONF_FILE
fi

if [ "$BITCOIN_NETWORK" == "testnet" ]
then
    if [ -f "$BITCOIN_CONF_FILE" ]
    then
        sed -i "1 s/^/testnet=1\n/" $BITCOIN_CONF_FILE
    fi
    PREFIX="test."
elif [ "$BITCOIN_NETWORK" == "regtest" ]
then
    if [ -f "$BITCOIN_CONF_FILE" ]
    then
        sed -i "1 s/^/regtest=1\n[regtest]\n/" $BITCOIN_CONF_FILE
    fi
elif [ -n "$BITCOIN_NETWORK" ] && [ "$BITCOIN_NETWORK" != "mainnet" ]
then
    exit_message "Unknown network \"$BITCOIN_NETWORK\"!"
fi

add_or_modify_line $BITCOIN_CONF_FILE port $BITCOIN_PORT

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
