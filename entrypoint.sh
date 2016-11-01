#!/bin/bash

if [ ! -e "$HOME/.shadowcoin/shadowcoin.conf" ]; then
    echo "Creating shadowcoin.conf"

    touch $HOME/.shadowcoin/shadowcoin.conf

    printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" \
        "daemon=1" \
        "addnode=shadow2b3ozvqmhm.onion" \
        "addnode=shadow3kdzs7v6is.onion" \
        "addnode=shadow5ea566kf2j.onion" \
        "onlynet=tor" \
        "proxy=127.0.0.1:9050" \
        "onion=127.0.0.1:9050" \
        "listen=1" \
        "rpcuser=${RPCUSER:-bitcoinrpc}" \
        "rpcpassword=${RPCPASSWORD:-`dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64`}" \
        "discover=1" \
        "bind=127.0.0.1:51737" \
        >> $HOME/.shadowcoin/shadowcoin.conf
fi

supervisord
