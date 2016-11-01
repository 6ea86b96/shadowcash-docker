#!/bin/bash

set -e

mkdir -p ~/.shadowcoin
mkdir -p ~/backups/shadowcoin
docker run -v "$HOME/.shadowcoin:/root/.shadowcoin" 0e8bee02/shadowcash-docker:latest fastsync.sh
docker run -d -p "51737:51737" -v "$HOME/.shadowcoin:/root/.shadowcoin" -v "$HOME/backups/shadowcoin:/backup" --name shadow --restart always 0e8bee02/shadowcash-docker:latest
