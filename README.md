# Primary PFP for Ethereum and Bitcoin

## Introduction

Primary PFP is a system for setting a primary profile picture (PFP) for Ethereum and Bitcoin addresses, inspired by [Primary ENS](https://support.ens.domains/en/articles/7890756-the-primary-name). This project aims to create a decentralized identity system with PFP ownership verified where users can sign in with their wallet addresses across various platforms.

Imagine a world with decentralized identity data, where you can sign in with your wallet address anywhere:

```python
# Example usage:
# name, avatar_url, is_avatar_collection_verified = get_identity(ethereum_address, "Ethereum")
# name, avatar_url, is_avatar_collection_verified = get_identity(bitcoin_address, "Bitcoin")

def get_public_identity(address: str, chain_name: str) -> Tuple[str, str, bool]:
    # Returns: (name, avatar_image_url, is_avatar_collection_verified)
    pass
```

And people can use different PFP in different community just like setting different profile picture in different discord channel:

```python
# Example usage:
# avatar_url = get_collection_avatar_url(ethereum_address, "Ethereum", collection_contract_address)
# avatar_url = get_collection_avatar_url(bitcoin_address, "Bitcoin", verified_collection_id)

def get_collection_avatar_url(address: str, chain_name: str, collection_id: str) -> str:
    # Returns: avatar_image_url
    pass
```

## Primary PFP for Ethereum

### Public Primary PFP

- [setPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L31)
- [setPrimaryByDelegateCash](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L40)
- [removePrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L49)
- [getPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L57)
- [getPrimaries](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L65)
- [getPrimaryAddress](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L74)

### Collection Primary PFP

- [setCollectionPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L25)
- [setCollectionPrimaryByDelegateCash](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L34)
- [removeCollectionPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L43)
- [hasCollectionPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L52)
- [getCollectionPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L61)

For contributing to Primary PFP for Ethereum, please refer to the [developer documentation](https://github.com/BittyIO/Primary-PFP/blob/main/dev.md).

## Primary PFP for Bitcoin Ordinals

### Primary PFP Definition

#### For [Verified](https://github.com/BittyIO/Primary-PFP/blob/main/verified_ordinals.md) Ordinals Collections:

1. Setting Primary PFP:
   - If a transfer event has the same `from` and `to` address with an empty `op_return`, that ordinals PFP becomes primary.
   - If `op_return` is `delegate:{bitcoinAddress}`, the PFP is set as primary and delegated to the specified Bitcoin address.
2. Validity: The primary ordinals PFP data is valid only while the ordinals remain in the wallet.
3. Override: The move out event or most recent primary ordinals data overrides previous data. Overridden data is removed.

#### For Non-Verified Ordinals Collections:

1. Validity: Ordinals must have a valid image content type.
2. Setting Primary PFP: A transfer event with the same `from` and `to` address and `op_return` is `set_primary` sets the ordinals PFP as primary.
3. No delegation function available.
4. Validity and override rules are the same as for verified collections.

### Collection Primary PFP Definition (Verified Ordinals Only)

1. Setting Collection Primary PFP:
   - Transfer event with same `from` and `to` address and `op_return` text "set_collection_primary" sets the ordinals PFP as collection primary.
   - For delegation, use `op_return` is `set_collection_primary_delegate:{bitcoinAddress}`.
2. Validity: Same as individual Primary PFP.
3. Override: The move out event or most recent collection primary ordinals data overrides previous data. Overridden data is removed.
