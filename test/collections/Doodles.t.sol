// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/Doodles.sol";

contract DoodlesTest is Test {
    Doodles public doodles;

    function setUp() public {
        doodles = new Doodles();
    }

    function testGetBaseURI() public {
        doodles.initialize("ipfs://QmPMc4tcBsMqLRuCQtPmPe84bpSjrC3Ky7t3JWuHXYB4aS/");
        assertEq(doodles.getBaseURI(), "ipfs://QmPMc4tcBsMqLRuCQtPmPe84bpSjrC3Ky7t3JWuHXYB4aS/");
    }

    function testGetTokenURI() public {
        doodles.initialize("ipfs://QmPMc4tcBsMqLRuCQtPmPe84bpSjrC3Ky7t3JWuHXYB4aS/");
        doodles.mintNext();
        assertEq(doodles.tokenURI(1), "ipfs://QmPMc4tcBsMqLRuCQtPmPe84bpSjrC3Ky7t3JWuHXYB4aS/1");
    }

    function testGetDoodlesInitHash() public view {
        bytes memory initCode = type(Doodles).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
