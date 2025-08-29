#!/bin/bash

sui genesis --from-config ~/genesis.yaml -f --with-faucet
cp ~/fullnode.yaml ~/.sui/sui_config
sed -i 's/metrics-address: ".*"/metrics-address: "0.0.0.0:9184"/' ~/.sui/sui_config/network.yaml
exec "$@"
