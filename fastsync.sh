#!/bin/bash

service tor start
service privoxy start

# Download the latest blockchain
echo "Downloading the latest blockchain.zip"
curl -o ~/.shadowcoin/blockchain.zip -L https://github.com/ShadowProject/blockchain/releases/download/latest/blockchain.zip

if [ -e "~/.shadowcoin/blockchain.zip" ]; then
    # Extract it to the ~/.shadowcoin folder
    echo "Extracting"
    unzip ~/.shadowcoin/blockchain.zip -d ~/.shadowcoin/
else
    echo "Download failed. Going to have to sync the slow way :("
fi
