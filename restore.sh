#!/bin/bash

shadowcoind stop
cp $HOME/.shadowcoin/wallet.dat $HOME/.shadowcoin/wallet-old.dat
cp /backup/wallet.dat $HOME/.shadowcoin/wallet.dat
shadowcoind
