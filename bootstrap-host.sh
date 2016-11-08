#!/bin/bash

set -e

mkdir -p ~/.shadowcoin
docker run -d -p "51737:51737" -v "$HOME/.shadowcoin:/root/.shadowcoin" -v "/etc/localtime:/etc/localtime:ro" --name shadow --restart always 0e8bee02/shadowcash-docker:latest
