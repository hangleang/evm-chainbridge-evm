#!/usr/bin/env sh

## STEPS
# 1. Start chains
# 2. Setup onchain contracts on both chains (This)
# 3. Run relayers

# git clone "https://github.com/ChainSafe/chainbridge-deploy.git"
# cd chainbridge-deploy/cb-sol-cli && make install

## SOURCE CHAIN SETUP #0

# deploy all contracts
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $DEPLOY_GAS_PRICE deploy --all --chainId $SRC_CHAIN_ID

# register resources
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge register-resource \
  --resourceId $TOKEN_RES_ID \
  --bridge $BRIDGE \
  --handler $TOKEN_HANDLER \
  --targetContract $TOKEN
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge register-resource \
  --resourceId $NFT_RES_ID \
  --bridge $BRIDGE \
  --handler $NFT_HANDLER \
  --targetContract $NFT 
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge register-generic-resource \
  --resourceId $GENERIC_RES_ID \
  --bridge $BRIDGE \
  --handler $GENERIC_HANDLER \
  --targetContract $GENERIC \
  --hash --deposit "" --execute "store(bytes32)"

# specify token semantics
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge set-burn \
  --bridge $BRIDGE \
  --handler $TOKEN_HANDLER \
  --tokenContract $TOKEN
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc20 add-minter \
  --minter $TOKEN_HANDLER \
  --erc20Address $TOKEN
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge set-burn \
  --bridge $BRIDGE \
  --handler $NFT_HANDLER \
  --tokenContract $NFT
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc721 add-minter \
  --minter $NFT_HANDLER \
  --erc721Address $NFT

## DESTINATION CHAIN SETUP #1

# deploy all contracts
cb-sol-cli --url $DST_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $DEPLOY_GAS_PRICE deploy --all --chainId $DST_CHAIN_ID

# register resources
cb-sol-cli --url $DST_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge register-resource \
  --resourceId $TOKEN_RES_ID \
  --bridge $BRIDGE \
  --handler $TOKEN_HANDLER \
  --targetContract $TOKEN
cb-sol-cli --url $DST_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge register-resource \
  --resourceId $NFT_RES_ID \
  --bridge $BRIDGE \
  --handler $NFT_HANDLER \
  --targetContract $NFT 
cb-sol-cli --url $DST_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge register-generic-resource \
  --resourceId $GENERIC_RES_ID \
  --bridge $BRIDGE \
  --handler $GENERIC_HANDLER \
  --targetContract $GENERIC \
  --hash --deposit "" --execute "store(bytes32)"

# specify token semantics
cb-sol-cli --url $DST_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge set-burn \
  --bridge $BRIDGE \
  --handler $TOKEN_HANDLER \
  --tokenContract $TOKEN
cb-sol-cli --url $DST_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc20 add-minter \
  --minter $TOKEN_HANDLER \
  --erc20Address $TOKEN
cb-sol-cli --url $DST_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE bridge set-burn \
  --bridge $BRIDGE \
  --handler $NFT_HANDLER \
  --tokenContract $NFT
cb-sol-cli --url $DST_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc721 add-minter \
  --minter $NFT_HANDLER \
  --erc721Address $NFT