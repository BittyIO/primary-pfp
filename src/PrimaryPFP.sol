// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.21;

import {IPrimaryPFP} from "./IPrimaryPFP.sol";
import {Initializable} from "../lib/openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";
import {ERC165} from "../lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

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

contract PrimaryPFP is IPrimaryPFP, ERC165, Initializable {
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

    DelegateCashInterface private dci;

    /**
     * @inheritdoc ERC165
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
        return interfaceId == type(IPrimaryPFP).interfaceId || super.supportsInterface(interfaceId);
    }

    function initialize(address dciAddress) public initializer {
        dci = DelegateCashInterface(dciAddress);
    }

    function setPrimary(address contract_, uint256 tokenId) external override {
        address tokenOwner = IERC721(contract_).ownerOf(tokenId);
        require(tokenOwner == msg.sender, "msg.sender is not the owner");
        _set(contract_, tokenId, false);
        emit PrimarySet(msg.sender, contract_, tokenId);
    }

    function setCollectionPrimary(address contract_, uint256 tokenId) external override {
        address tokenOwner = IERC721(contract_).ownerOf(tokenId);
        require(tokenOwner == msg.sender, "msg.sender is not the owner");
        _set(contract_, tokenId, true);
        emit CollectionPrimarySet(msg.sender, contract_, tokenId);
    }

    function setPrimaryByDelegateCash(address contract_, uint256 tokenId) external override {
        _setPrimaryByDelegateCash(contract_, tokenId, false);
    }

    function setCollectionPrimaryByDelegateCash(address contract_, uint256 tokenId) external override {
        _setPrimaryByDelegateCash(contract_, tokenId, true);
    }

    function _setPrimaryByDelegateCash(address contract_, uint256 tokenId, bool isCollection) internal {
        address tokenOwner = IERC721(contract_).ownerOf(tokenId);
        require(
            dci.checkDelegateForERC721(msg.sender, tokenOwner, contract_, tokenId, bytes32(0)) ||
                dci.checkDelegateForContract(msg.sender, tokenOwner, contract_, bytes32(0)) ||
                dci.checkDelegateForAll(msg.sender, tokenOwner, bytes32(0)),
            "msg.sender is not delegated"
        );
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
            require(lastOwner != msg.sender, "duplicated set");
            pfpOwners[pfpHash] = msg.sender;
            PFP memory pfp = primaryPFPs[msg.sender];
            if (pfp.contract_ != address(0)) {
                emit PrimaryRemoved(msg.sender, pfp.contract_, pfp.tokenId);
                delete pfpOwners[_pfpKey(pfp.contract_, pfp.tokenId)];
            }
            primaryPFPs[msg.sender] = PFP(contract_, tokenId);
            if (lastOwner == address(0)) {
                return;
            }
            emit PrimaryRemoved(lastOwner, contract_, tokenId);
            delete primaryPFPs[lastOwner];
            return;
        }

        lastOwner = (tokenId != 0) ? collectionPFPOwners[pfpHash] : collectionPrimaryPFPZeroOwners[contract_];
        require(lastOwner != msg.sender, "duplicated set");

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

    function removePrimary(address contract_, uint256 tokenId) external override {
        address owner = IERC721(contract_).ownerOf(tokenId);
        require(owner == msg.sender, "msg.sender is not the owner");
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = pfpOwners[pfpHash];
        require(boundAddress != address(0), "primary PFP not set");

        emit PrimaryRemoved(boundAddress, contract_, tokenId);
        delete pfpOwners[pfpHash];
        delete primaryPFPs[boundAddress];
    }

    function removeCollectionPrimary(address contract_, uint256 tokenId) external override {
        address owner = IERC721(contract_).ownerOf(tokenId);
        require(owner == msg.sender, "msg.sender is not the owner");
        bytes32 pfpHash = _pfpKey(contract_, tokenId);
        address boundAddress = collectionPFPOwners[pfpHash];
        require(boundAddress != address(0), "collection primary PFP not set");

        emit CollectionPrimaryRemoved(boundAddress, contract_, tokenId);
        delete collectionPFPOwners[pfpHash];
        delete collectionPrimaryPFPs[boundAddress][contract_];
    }

    function getPrimary(address addr) external view override returns (address, uint256) {
        PFP memory pfp = primaryPFPs[addr];
        return (pfp.contract_, pfp.tokenId);
    }

    function hasCollectionPrimary(address addr, address contract_) external view override returns (bool) {
        return
            collectionPrimaryPFPs[addr][contract_] != 0 ||
            collectionPrimaryPFPIdZero[_collectionPFPKey(addr, contract_)];
    }

    function getCollectionPrimary(address addr, address contact_) external view override returns (uint256) {
        return collectionPrimaryPFPs[addr][contact_];
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

    function _pfpKey(address collection, uint256 tokenId) internal pure virtual returns (bytes32) {
        return keccak256(abi.encodePacked(collection, tokenId));
    }

    function _collectionPFPKey(address owner, address collection) internal pure virtual returns (bytes32) {
        return keccak256(abi.encodePacked(owner, collection));
    }
}
