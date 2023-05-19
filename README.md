# evm-chainbridge-evm
Running Chainbridge between two geth network with 3 relayers
## Prerequisites
- Docker, docker-compose
- [cb-sol-cli](https://github.com/ChainSafe/chainbridge-deploy/tree/master/cb-sol-cli#cb-sol-cli-documentation)

## Get started
Start both chains, Setup on-chain & Run those 3 relayers
```bash
docker compose up -V
```
wait until the setup is completed, and relayers is up:
![/relayers_is_running](./relayers_is_running.png)

test the bridge with bash script
```bash
./test_bridge.sh
```
