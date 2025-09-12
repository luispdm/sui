#!/bin/bash

sed -i 's/metrics-address: ".*"/metrics-address: "0.0.0.0:9184"/' /opt/sui/config/validator0-8080.yaml
sed -i -E 's#^([[:space:]]*genesis-file-location:[[:space:]]*).*$#\1/opt/sui/config/genesis.blob#' /opt/sui/config/validator0-8080.yaml

exec "$@"
