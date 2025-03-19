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

- get salt by [create2crunch](https://github.com/BittyIO/create2crunch) and change it in [deploy script](https://github.com/BittyIO/Primary-PFP/blob/main/script/deploy.s.sol#L23)


- deploy and verify in etherscan
```
forge script --broadcast -vvvv --rpc-url {rpc_url} \
    --private-key {private_key} \
    --etherscan-api-key {ethercan_api_key} \
    script/deploy.s.sol:Deploy
```

```
forge verify-contract \
    --chain-id {chain_id} \
    {contract_address} \
    --etherscan-api-key {ethercan_api_key} \
    src/PrimaryPFP.sol:PrimaryPFP
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
|Ethereum Mainnet|[0x0000000000749f588c82E9cd5A67C91314e56458](https://etherscan.io/address/0x0000000000749f588c82E9cd5A67C91314e56458)|

|Testnet Chain|Address|
|---|---|
|Ethereum Sepolia|[0x0000000000749f588c82E9cd5A67C91314e56458](https://sepolia.etherscan.io/address/0x0000000000749f588c82E9cd5A67C91314e56458)|

If you'd like to get the Primary PFP on another EVM chain, feel free to submit an issue here.
