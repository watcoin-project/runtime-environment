#!/usr/bin/env bash

function exit_message {
    (>&2 echo "$@")
    exit 1
}

function rpc_call {
    id=$1
    method=$2
    params=$3
    user=$4
    url=$5
    curl --connect-timeout 5 \
        --data-binary "{\"jsonrpc\": \"1.0\", \"id\": \"$id\", \"method\": \"$method\", \"params\": [$params]}" \
        --header "'Content-Type: text/plain;'" \
        --request POST \
        --silent \
        --user $user \
        $url
}

if [ -z "$BITCOIN_RPC_PORT" ]
then
    exit_message "BITCOIN_RPC_PORT not set!"
fi

if [ -z "$BITCOIN_RPC_USER" ]
then
    exit_message "BITCOIN_RPC_USER not set!"
fi

if [ -z "$BITCOIN_RPC_PASSWORD" ]
then
    exit_message "BITCOIN_RPC_PASSWORD not set!"
fi

if [ -z "$BITCOIN_URL" ]
then
    exit_message "BITCOIN_URL not set!"
fi

url=http://$BITCOIN_URL:$BITCOIN_RPC_PORT

auth=$BITCOIN_RPC_USER:$BITCOIN_RPC_PASSWORD

response=$(rpc_call getminingaddresserror getaddressesbylabel '"mining"' $auth $url)
error=$(python3 -c "import json; print(json.loads('$response')[\"error\"])")
if [ "$error" != "None" ]
then
    rpc_call createminingaddress getnewaddress '"mining"' $auth $url
fi

response=$(rpc_call getminingaddress getaddressesbylabel '"mining"' $auth $url)

error=$(python3 -c "import json; print(json.loads('$response')[\"error\"])")
if [ "$error" != "None" ]
then
    exit_message $error
fi

address=$(python3 -c "import json; print(list(json.loads('$response')[\"result\"].keys()).pop())")

minerd --algo sha256d \
    --url $url \
    --user $BITCOIN_RPC_USER \
    --pass $BITCOIN_RPC_PASSWORD \
    --no-longpoll \
    --no-getwork \
    --no-stratum \
    --coinbase-addr=$address \
    $@
