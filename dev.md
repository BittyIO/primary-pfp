# How to run the project
Install [foundry](https://book.getfoundry.sh/)

- build
```
forge build
```

- test
```
forge test 
```

- gas-report
```
forge test --gas-report
```

- format code
install [prettier-solidity](https://github.com/prettier-solidity/prettier-plugin-solidity)

```
npx prettier --write --plugin=prettier-plugin-solidity 'src/**/*.sol' 'test/**/*.sol'
```

- get salt by [create2crunch](https://github.com/0age/create2crunch) and change it in [deploy script](https://github.com/BittyIO/Primary-PFP/blob/main/script/deploy.s.sol#L23)


- deploy and verify in etherscan
```
forge script --broadcast -vvvv --rpc-url {rpc_url} \
    --private-key {private_key} \
    --etherscan-api-key {ethercan_api_key} \
    script/deploy.s.sol:Deploy
```
```
forge verify-check {id} \
    --etherscan-api-key {ethercan_api_key} \
    --chain-id {chain_id}
```

- initialize with delegate cash address
```
0x00000000000000447e69651d841bd8d104bed493
```


## Finalized Deployment

|Mainnet Chain|Address|
|---|---|
|Ethereum|[]()|

|Testnet Chain|Address|
|---|---|
|Ethereum Sepolia|[0x000000074F2C716416DB00337367bac9d28Db3e0](https://sepolia.etherscan.io/address/0x000000074F2C716416DB00337367bac9d28Db3e0)|

If you'd like to get the Primary on another EVM chain, anyone in the community can deploy to the same address and make a PR to add link here.
