#!/bin/bash

if [ ! -f /root/.sui/sui_config/genesis.blob ]; then
    echo "Creating new genesis..."
    sui genesis --from-config /root/genesis.yaml -f --with-faucet
else
    echo "Genesis files already exist, skipping initialization"
fi
