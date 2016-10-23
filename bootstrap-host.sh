#!/bin/bash

set -e

mkdir -p ~/.shadowcoin
mkdir -p ~/backups/shadowcoin
docker run -v "$HOME/.shadowcoin:/root/.shadowcoin" 0e8bee02/shadowcoin:1.5.0.2 fastsync.sh
docker run -d -v "shadowcoin-config:/root/.shadowcoin" -v "$HOME/backups/shadowcoin:/backup" --name shadow 0e8bee02/shadowcoin:1.5.0.2
