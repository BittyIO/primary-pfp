// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import {TestPFP} from "src/TestPFP.sol";
import {Initializable} from "lib/openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract Mfers is TestPFP, Initializable {
    constructor() TestPFP("mfer", "MFER") {
        transferOwnership(tx.origin);
    }

    function initialize(string memory baseURI_) public initializer {
        baseURI = baseURI_;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
    }
}
