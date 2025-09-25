# local network

This docker compose creates a network with three validators, one fullnode and a stress test container that makes a lot of requests to the fullnode, so that latency of the application can be analyzed. The stress test container is built with [this dockerfile](../stress/alternative.dockerfile). The requests the stress container makes are coin transfers and calls to a smart contract, so that transactions for both owned objects and shared objects occur.

The docker compose also includes prometheus, prometheus node exporter and grafana to collect and show the data, as well as a container called `genesis` that creates the necessary files for the network to be spawned. See [genesis.yaml](genesis.yaml) for more details.

**All the containers except for the stress container create external volumes. If you tear down the docker compose, make sure to remove those volumes too, otherwise the network will start from the previous state on the next compose restart.**

## Requirements
To run the docker compose, you must first build the stress image from the root of the repo with the command:
```bash
docker build -t stress:testing -f docker/stress/alternative.dockerfile .
```

`alternative.dockerfile` is required as of Sep 2025 the image built from the [other dockerfile](../stress/Dockerfile) doesn't work.

## How to run
```bash
docker compose up -d # -d is optional if you don't want to see the logs
```

By default, the epoch duration is set to 30m. If you want to change that, just prepend the environment variable `EPOCH` to the command. Example:
```shell
EPOCH=3600000 docker compose up -d # epoch set to 60m
```

Short epochs are not recommended as transactions are rejected on epoch change (as per [Sui's design](https://docs.sui.io/concepts/sui-architecture/transaction-lifecycle#epoch-change)), so latency spikes will be very common.

## Is it working?
To check if the network is running, head to: https://custom.suiscan.xyz/custom/txs/tx-blocks?network=http%3A%2F%2F127.0.0.1%3A9000. You should see blocks being produced.

If the stress container is doing its job, you should be seeing something like this from the container log:
```
TPS = 110.666664, CPS = 125.666664, latency_ms(min/p50/p99/max) = 218/2223/2437/2445, num_success_tx = 996, num_error_tx = 0, num_expected_error_tx = 0, num_success_cmds = 1131, no_gas = 0, submitted = 1012, in_flight = 154
```

If you want to see the validators' metrics, head to Grafana's address at the drilldown metrics section: http://localhost:3000/a/grafana-metricsdrilldown-app/drilldown.

**Resource usage is quite intensive with this configuration. Make sure to set a high CPU, RAM, and storage limit in your Docker settings.**
