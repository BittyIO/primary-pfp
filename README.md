# Why Primary PFP?

Primary PFP is for setting primary PFP for an Ethereum/Bitcoin address, inspired by [Primary ENS](https://support.ens.domains/en/articles/7890756-the-primary-name).


Image the world with decentralized identity data providing function that you can sign in with your wallet address anywhere:

```
// alice.eth, "https://images.wrappedpunks.com/images/punks/6125.png", true = bitty.getIdentiy(0xaliceEthreumAddress, "Ethereum")
// alice.btc, "https://ordiscan.com/content/4cf11ab95d73b22a73ac1e74861a71ffd376739b4246c9b14bf0bc01e734f1a7i0", true = bitty.getIdentiy(bc1pxxxxAliceBitcoinAddress, "Bitcoin")

func (name, avatar_image_url, is_avatar_collection_verified) = bitty.getIdentity(address, chainName);
```

While we have Primary ENS, we don't have Primary PFP yet for Ethereum, and none of primary [BTCName](https://github.com/BtcName) and
primary PFP for [Bitcoin Ordinals](https://github.com/ordinals/ord) is made yet.

This project try to finish the Primary PFP for both Etherum and Bitcoin, Etherum for solidity code and Bitcoin for ordinals transaction specification for indexers.

# Primary PFP for Ethereum

- Public primary PFP


 - [setPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L31)

 - [setPrimaryByDelegateCash](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L40)

 - [removePrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L49)

 - [getPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L57)

 - [getPrimaries](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L65)

 - [getPrimaryAddress](https://github.com/BittyIO/Primary-PFP/blob/main/src/IPrimaryPFP.sol#L74)
 

- Collection primary PFP for communities


 - [setCollectionPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L25)
 
 - [setCollectionPrimaryByDelegateCash](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L34)

 - [removeCollectionPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L43)

 - [hasCollectionPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L52)

 - [getCollectionPrimary](https://github.com/BittyIO/Primary-PFP/blob/main/src/ICollectionPrimaryPFP.sol#L61)

# Primary PFP for Bitcoin Ordinals
// TBD

If you want to contribute the project, read dev doc [here](https://github.com/BittyIO/Primary-PFP/blob/main/dev.md)
