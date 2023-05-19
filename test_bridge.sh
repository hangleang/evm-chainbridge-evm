#!/bin/bash

## STEPS
# 1. Mint & Approve on SOURCE CHAIN
# 2. Deposit/Lock & Transfer/Mint
# 3. Approve on DESTINATION CHAIN
# 4. Withdraw/Redeem & Release/Unlock

source .env
# override gateway to test in localhost
SRC_GATEWAY="http://localhost:8545"
DST_GATEWAY="http://localhost:8555"

# mint some tokens && approve handlers
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc20 mint \
  --erc20Address $TOKEN \
  --amount $TOKEN_AMOUNT
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc721 mint \
  --erc721Address $NFT \
  --id $NFT_ID
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc20 approve \
  --amount $TOKEN_AMOUNT \
  --erc20Address $TOKEN \
  --recipient $TOKEN_HANDLER
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc721 approve \
  --id $NFT_ID \
  --erc721Address $NFT \
  --recipient $NFT_HANDLER

# check after transactions
echo -e "\n====== Check Balance, Owner & Allowance of $DEPLOYER_ADDR on SOURCE CHAIN ======"
cb-sol-cli --url $SRC_GATEWAY erc20 balance --erc20Address $TOKEN --address $DEPLOYER_ADDR # $TOKEN_AMOUNT balance on $DEPLOYER_ADDR
cb-sol-cli --url $SRC_GATEWAY erc721 owner --erc721Address $NFT --id $NFT_ID # owner of $NFT_ID is $DEPLOYER_ADDR
cb-sol-cli --url $SRC_GATEWAY erc20 allowance --erc20Address $TOKEN --spender $TOKEN_HANDLER --owner $DEPLOYER_ADDR # allowance to $TOKEN_HANDLER on behalf of $DEPLOYER_ADDR
echo -e "================================================================================\n"

# deposit & mint
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc20 deposit \
  --amount $TOKEN_AMOUNT \
  --dest $DST_CHAIN_ID \
  --bridge $BRIDGE \
  --recipient $BOB \
  --resourceId $TOKEN_RES_ID
cb-sol-cli --url $SRC_GATEWAY --privateKey $DEPLOYER_PK --gasPrice $TXN_GAS_PRICE erc721 deposit \
  --id $NFT_ID \
  --dest $DST_CHAIN_ID \
  --bridge $BRIDGE \
  --recipient $CHARLIE \
  --resourceId $NFT_RES_ID

echo "waiting 10 block confirmations..."
sleep 30;

# check after transactions
echo -e "\n====== Check Balance of $DEPLOYER_ADDR on SOURCE CHAIN, Owner & Balance of $BOB on DST CHAIN ======"
cb-sol-cli --url $SRC_GATEWAY erc20 balance --erc20Address $TOKEN --address $DEPLOYER_ADDR # 0 balance on $DEPLOYER_ADDR
cb-sol-cli --url $DST_GATEWAY erc20 balance --erc20Address $TOKEN --address $BOB # $TOKEN_AMOUNT balance on $BOB
cb-sol-cli --url $DST_GATEWAY erc721 owner --erc721Address $NFT --id $NFT_ID # owner of $NFT_ID is $CHARLIE
echo -e "===================================================================================================\n"

# approve on destination chain
cb-sol-cli --url $DST_GATEWAY --privateKey $BOB_PK --gasPrice $TXN_GAS_PRICE erc20 approve \
  --amount $TOKEN_AMOUNT \
  --erc20Address $TOKEN \
  --recipient $TOKEN_HANDLER
cb-sol-cli --url $DST_GATEWAY --privateKey $CHARLIE_PK --gasPrice $TXN_GAS_PRICE erc721 approve \
  --id $NFT_ID \
  --erc721Address $NFT \
  --recipient $NFT_HANDLER

# check allowance
cb-sol-cli --url $DST_GATEWAY erc20 allowance --erc20Address $TOKEN --spender $TOKEN_HANDLER --owner $BOB # allowance to $TOKEN_HANDLER on behalf of $BOB

# withdraw & release
cb-sol-cli --url $DST_GATEWAY --privateKey $BOB_PK --gasPrice $TXN_GAS_PRICE erc20 deposit \
  --amount $TOKEN_AMOUNT \
  --dest $SRC_CHAIN_ID \
  --bridge $BRIDGE \
  --recipient $BOB \
  --resourceId $TOKEN_RES_ID
cb-sol-cli --url $DST_GATEWAY --privateKey $CHARLIE_PK --gasPrice $TXN_GAS_PRICE erc721 deposit \
  --id $NFT_ID \
  --dest $SRC_CHAIN_ID \
  --bridge $BRIDGE \
  --recipient $CHARLIE \
  --resourceId $NFT_RES_ID

echo "waiting 10 block confirmations..."
sleep 30;

# check after transactions
echo -e "\n====== Check Balance of $BOB on DST CHAIN, Owner & Balance of $BOB on SOURCE CHAIN ======"
cb-sol-cli --url $DST_GATEWAY erc20 balance --erc20Address $TOKEN --address $BOB # 0 balance on $BOB
cb-sol-cli --url $SRC_GATEWAY erc20 balance --erc20Address $TOKEN --address $BOB # $TOKEN_AMOUNT balance on $BOB
cb-sol-cli --url $SRC_GATEWAY erc721 owner --erc721Address $NFT --id $NFT_ID # owner of $NFT_ID is $CHARLIE
echo -e "===================================================================================================\n"

