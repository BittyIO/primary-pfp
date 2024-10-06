// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import {IPrimaryPFP} from "./IPrimaryPFP.sol";
import {ICollectionPrimaryPFP} from "./ICollectionPrimaryPFP.sol";
import {ICollectionVerification} from "./ICollectionVerification.sol";
import {Initializable} from "../lib/openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";
import {ERC165} from "../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title Set primary PFP by binding a PFP to an address like primary ENS.
 *
 */

interface DelegateCashInterface {
    function checkDelegateForAll(address delegate, address vault, bytes32 rights) external view returns (bool);

    function checkDelegateForContract(
        address delegate,
        address vault,
        address contract_,
        bytes32 rights
    ) external view returns (bool);

    function checkDelegateForERC721(
        address delegate,
        address vault,
        address contract_,
        uint256 tokenId,
        bytes32 rights
    ) external view returns (bool);
}

contract PrimaryPFP is IPrimaryPFP, ICollectionPrimaryPFP, ICollectionVerification, Ownable, ERC165, Initializable {
    error MsgSenderNotOwner();
    error MsgSenderNotDelegated();
    error PrimaryNotSet();
    error PrimaryCollectionNotSet();
    error PrimaryDuplicateSet();
    error PrimaryCollectionDuplicateSet();

    // keccak256(abi.encode(collection, tokenId)) => ownerAddress
    mapping(bytes32 => address) private pfpOwners;
    // ownerAddress => PFPStruct
    mapping(address => PFP) private primaryPFPs;

    // keccak256(abi.encode(collection, tokenId)) => ownerAddress
    mapping(bytes32 => address) private collectionPFPOwners;

    // keccak256(abi.encode(address, collection)) => isCollectionIdZero,
    // since solidity return 0 when empty, so we need this for collection id 0
    mapping(bytes32 => bool) private collectionPrimaryPFPIdZero;
    mapping(address => address) private collectionPrimaryPFPZeroOwners;

    // ownerAddress => mapping(collection_contract_, id)
    mapping(address => mapping(address => uint256)) private collectionPrimaryPFPs;

    mapping(address => bool) private verifications;

    DelegateCashInterface private dc;

    /**
     * @inheritdoc ERC165
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
        return interfaceId == type(IPrimaryPFP).interfaceId || super.supportsInterface(interfaceId);
    }

    function initialize(address dcAddress) public initializer {
        dc = DelegateCashInterface(dcAddress);
    }

    // Primary PFP functions
    function setPrimary(address contract_, uint256 tokenId) external override {
        address tokenOwner = IERC721(contract_).ownerOf(tokenId);
        if (tokenOwner != msg.sender) {
            revert MsgSenderNotOwner();
        }
        _set(contract_, tokenId, false);
        emit PrimarySet(msg.sender, contract_, tokenId);
    }

    function setPrimaryByDelegateCash(address contract_, uint256 tokenId) external override {
        _setPrimaryByDelegateCash(contract_, tokenId, false);
    }

    function removePrimary(address contract_, uint256 tokenId) external override {
        address owner = IERC721(contract_).ownerOf(tokenId);
        if (owner != msg.sender) {
            revert MsgSenderNotOwner();
        }
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = pfpOwners[pfpHash];
        if (boundAddress == address(0)) {
            revert PrimaryNotSet();
        }
        emit PrimaryRemoved(boundAddress, contract_, tokenId);
        delete pfpOwners[pfpHash];
        delete primaryPFPs[boundAddress];
    }

    function getPrimary(address addr) external view override returns (PFP memory) {
        PFP memory pfp = primaryPFPs[addr];
        if (pfp.contract_ == address(0)) {
            return pfp;
        }
        pfp.isCollectionVerified = verifications[pfp.contract_];
        return pfp;
    }

    function getPrimaries(address[] calldata addrs) external view returns (PFP[] memory) {
        uint256 length = addrs.length;
        PFP[] memory result = new PFP[](length);
        for (uint256 i; i < length; ) {
            result[i] = primaryPFPs[addrs[i]];
            unchecked {
                ++i;
            }
        }
        return result;
    }

    function getPrimaryAddress(address contract_, uint256 tokenId) external view override returns (address) {
        return pfpOwners[_pfpKey(contract_, tokenId)];
    }

    // Collection primary functions
    function setCollectionPrimaryByDelegateCash(address contract_, uint256 tokenId) external override {
        _setPrimaryByDelegateCash(contract_, tokenId, true);
    }

    function setCollectionPrimary(address contract_, uint256 tokenId) external override {
        address tokenOwner = IERC721(contract_).ownerOf(tokenId);
        if (tokenOwner != msg.sender) {
            revert MsgSenderNotOwner();
        }
        _set(contract_, tokenId, true);
        emit CollectionPrimarySet(msg.sender, contract_, tokenId);
    }

    function removeCollectionPrimary(address contract_, uint256 tokenId) external override {
        address owner = IERC721(contract_).ownerOf(tokenId);
        if (owner != msg.sender) {
            revert MsgSenderNotOwner();
        }
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = collectionPFPOwners[pfpHash];
        if (boundAddress == address(0)) {
            revert PrimaryCollectionNotSet();
        }
        emit CollectionPrimaryRemoved(boundAddress, contract_, tokenId);
        delete collectionPFPOwners[pfpHash];
        delete collectionPrimaryPFPs[boundAddress][contract_];
    }

    function hasCollectionPrimary(address addr, address contract_) external view override returns (bool) {
        return
            collectionPrimaryPFPs[addr][contract_] != 0 ||
            collectionPrimaryPFPIdZero[_collectionPFPKey(addr, contract_)];
    }

    function getCollectionPrimary(address addr, address contact_) external view override returns (uint256) {
        return collectionPrimaryPFPs[addr][contact_];
    }

    // Collection verification functions
    function addVerification(address[] calldata contracts) external override onlyOwner {
        uint contractsLength = contracts.length;
        for (uint i = 0; i < contractsLength; i++) {
            address contract_ = contracts[i];
            verifications[contract_] = true;
            emit CollectionVerified(contract_);
        }
    }

    function removeVerification(address[] calldata contracts) external override onlyOwner {
        uint contractsLength = contracts.length;
        for (uint i = 0; i < contractsLength; i++) {
            address contract_ = contracts[i];
            verifications[contract_] = false;
            emit CollectionVerificationRemoved(contract_);
        }
    }

    function isCollectionVerified(address contract_) external view override returns (bool) {
        return verifications[contract_];
    }

    // internal functions
    function _pfpKey(address collection, uint256 tokenId) internal pure virtual returns (bytes32) {
        return keccak256(abi.encodePacked(collection, tokenId));
    }

    function _collectionPFPKey(address owner, address collection) internal pure virtual returns (bytes32) {
        return keccak256(abi.encodePacked(owner, collection));
    }

    function _setPrimaryByDelegateCash(address contract_, uint256 tokenId, bool isCollection) internal {
        address tokenOwner = IERC721(contract_).ownerOf(tokenId);
        if (
            !(dc.checkDelegateForERC721(msg.sender, tokenOwner, contract_, tokenId, bytes32(0)) ||
                dc.checkDelegateForContract(msg.sender, tokenOwner, contract_, bytes32(0)) ||
                dc.checkDelegateForAll(msg.sender, tokenOwner, bytes32(0)))
        ) {
            revert MsgSenderNotDelegated();
        }
        _set(contract_, tokenId, isCollection);
        if (!isCollection) {
            emit PrimarySetByDelegateCash(msg.sender, contract_, tokenId);
            return;
        }
        emit CollectionPrimarySetByDelegateCash(msg.sender, contract_, tokenId);
    }

    function _set(address contract_, uint256 tokenId, bool isCollection) internal {
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address lastOwner;
        if (!isCollection) {
            lastOwner = pfpOwners[pfpHash];
            if (lastOwner == msg.sender) {
                revert PrimaryDuplicateSet();
            }
            pfpOwners[pfpHash] = msg.sender;
            PFP memory pfp = primaryPFPs[msg.sender];
            if (pfp.contract_ != address(0)) {
                emit PrimaryRemoved(msg.sender, pfp.contract_, pfp.tokenId);
                delete pfpOwners[_pfpKey(pfp.contract_, pfp.tokenId)];
            }
            primaryPFPs[msg.sender] = PFP(contract_, tokenId, false);
            if (lastOwner == address(0)) {
                return;
            }
            emit PrimaryRemoved(lastOwner, contract_, tokenId);
            delete primaryPFPs[lastOwner];
            return;
        }

        lastOwner = (tokenId != 0) ? collectionPFPOwners[pfpHash] : collectionPrimaryPFPZeroOwners[contract_];
        if (lastOwner == msg.sender) {
            revert PrimaryCollectionDuplicateSet();
        }
        collectionPFPOwners[pfpHash] = msg.sender;
        uint256 collectionTokenId = collectionPrimaryPFPs[msg.sender][contract_];
        if (collectionTokenId != 0 || collectionPrimaryPFPZeroOwners[contract_] == msg.sender) {
            emit CollectionPrimaryRemoved(msg.sender, contract_, collectionTokenId);
            if (collectionTokenId != 0) {
                delete collectionPrimaryPFPs[msg.sender][contract_];
            }
        }
        collectionPrimaryPFPs[msg.sender][contract_] = tokenId;
        if (tokenId == 0) {
            collectionPrimaryPFPIdZero[_collectionPFPKey(lastOwner, contract_)] = false;
            collectionPrimaryPFPIdZero[_collectionPFPKey(msg.sender, contract_)] = true;
            collectionPrimaryPFPZeroOwners[contract_] = msg.sender;
        } else if (collectionPrimaryPFPZeroOwners[contract_] == msg.sender) {
            delete collectionPrimaryPFPZeroOwners[contract_];
        }
        if (lastOwner == address(0)) {
            return;
        }
        emit CollectionPrimaryRemoved(lastOwner, contract_, tokenId);
        delete collectionPrimaryPFPs[lastOwner][contract_];
    }
}
