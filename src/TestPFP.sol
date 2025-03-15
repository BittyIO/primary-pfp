// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title TestPFP
 * @dev This contract is only for deployment on testnet for better testing.
 */
contract TestPFP is Ownable, ERC721Enumerable {
    string public baseURI;
    uint256 public collectionLimit;
    mapping(address => uint256) public mintCounts;
    uint256 private _currentTokenId = 0;

    constructor(string memory name, string memory symbol) Ownable() ERC721(name, symbol) {
        baseURI = "https://MintableERC721/";
        collectionLimit = 10000;
    }

    /**
     * @dev Function to mint the next available token ID.
     * @return A boolean that indicates if the operation was successful.
     */
    function mintNext() external returns (bool) {
        require(_currentTokenId < collectionLimit, "exceed collection limit");

        mintCounts[_msgSender()] += 1;
        require(mintCounts[_msgSender()] <= 10, "exceed mint limit");

        _currentTokenId += 1;
        _mint(_msgSender(), _currentTokenId);
        return true;
    }

    /**
     * @dev Function to mint the next available token ID.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(uint256 tokenId) external returns (bool) {
        require(_currentTokenId < collectionLimit, "exceed collection limit");

        mintCounts[_msgSender()] += 1;
        require(mintCounts[_msgSender()] <= 10, "exceed mint limit");

        _currentTokenId += 1;
        _mint(_msgSender(), tokenId);
        return true;
    }

    function setCollectionLimit(uint256 collectionLimit_) external onlyOwner {
        collectionLimit = collectionLimit_;
    }

    function getBaseURI() external view returns (string memory) {
        return baseURI;
    }
}
