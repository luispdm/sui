#!/bin/bash

sed -i "s/metrics-address: \".*\"/metrics-address: \"0.0.0.0:${RPC_PORT}\"/" /opt/sui/config/${NAME}-8080.yaml
sed -i -E 's#^([[:space:]]*genesis-file-location:[[:space:]]*).*$#\1/opt/sui/config/genesis.blob#' /opt/sui/config/${NAME}-8080.yaml

exec "$@"
