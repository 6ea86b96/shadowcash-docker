#!/bin/bash

# Crappy hack to wait for tor to start so that the hidden service address is
# available. Need to fix this up.
sleep 10

shadowcoind -externalip=$(cat /var/lib/tor/shadowcash-service/hostname)
